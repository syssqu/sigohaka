# -*- coding: utf-8 -*-
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :input_attendance_time, :calculate]
  before_action :authenticate_user!

  # 
  #
  #
  def index

    init
    create_attendances

    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    @others = get_attendance_others_info

  end

  # 
  #
  #
  def new
    @attendance = Attendance.new
  end

  # データ初期化
  # 
  #
  def init_attendances
    init

    sql = "pattern=?,start_time=?,end_time=?,byouketu=?,kekkin=?,hankekkin=?," +
      "tikoku=?,soutai=?,gaisyutu=?,tokkyuu=?,furikyuu=?,yuukyuu=?,syuttyou=?,over_time=?," +
      "holiday_time=?,midnight_time=?,break_time=?,kouzyo_time=?,work_time=?,remarks=?"

    ActiveRecord::Base.transaction do

      @attendances.where("holiday = '0'").update_all([sql,
          current_user.kinmu_patterns.first.code,
          current_user.kinmu_patterns.first.start_time,
          current_user.kinmu_patterns.first.end_time,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          0.00, 0.00, 0.00, 0.00, 0.00,
          current_user.kinmu_patterns.first.work_time,
          nil
        ])
      
      @attendances.where("holiday = '1'").update_all([sql,
          "",
          "",
          "",
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          0.00, 0.00, 0.00, 0.00, 0.00,
          0.00,
          nil
        ])
    end

    redirect_to attendances_path, notice: '勤怠データを初期化しました。'
 
  rescue => e
    render :index, notice: '勤怠データの初期化に失敗しました。'
  end

  # 
  #
  #
  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to attendances_path, notice: '登録しました。'
    else
      render :new
    end
  end

  def edit
  end

  # def confirm
  #   @attendance = Attendance.new(params[:attendance])

  #   if ! attendance.valid?
  #     render :edit
  #   end
  # end

  # 
  #
  #
  def update
    @attendance.is_blank_start_time = false
    @attendance.is_blank_end_time = false

    if params[:attendance]['start_time(4i)'.to_sym].blank? or params[:attendance]['start_time(5i)'.to_sym].blank?
      @attendance.is_blank_start_time = true
    end

    if params[:attendance]['end_time(4i)'.to_sym].blank? or params[:attendance]['end_time(5i)'.to_sym].blank?
      @attendance.is_blank_end_time = true
    end
    
    if @attendance.update_attributes(attendance_params)
      redirect_to attendances_path, notice: '更新しました。'
    else
      render :edit
    end
  end

  # 勤務パターンが変更された際に出退勤時刻を変更する
  # 勤怠情報編集画面にて呼び出される
  #
  def input_attendance_time

    @pattern = KinmuPattern.find_by(id: params[:pattern])
    @time_blank = false

    if @pattern.nil?
      @time_blank = true
    else
      @attendance.start_time = @pattern.start_time
      @attendance.end_time = @pattern.end_time
    end
  end

  # 
  #
  #
  def calculate
    
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    @pattern = KinmuPattern.find(params[:pattern])

    Rails.logger.info("pattern_start_date: " + @pattern.start_time.to_s)
    Rails.logger.info("pattern_end_date: " + @pattern.end_time.to_s)
    Rails.logger.info("pattern_end_date - pattern_start_date: " + (@pattern.end_time - @pattern.start_time).to_s)

    attendance_start_time = Time.local(@pattern.start_time.year, @pattern.start_time.month, @pattern.start_time.day, params[:start_time_hour], params[:start_time_minute], 0)
    attendance_end_time = Time.local(@pattern.end_time.year, @pattern.end_time.month, @pattern.end_time.day, params[:end_time_hour], params[:end_time_minute], 0)

    Rails.logger.info("input_start_date: " + attendance_start_time.to_s)
    Rails.logger.info("input_start_date: " + attendance_end_time.to_s)
    Rails.logger.info("input_end_date - input_start_date: " + (attendance_end_time - attendance_start_time).to_s)
    
    @attendance.calculate(@pattern, attendance_start_time, attendance_end_time)
  end

  # 
  #
  #
  def print

    @nen_gatudo = params[:nen_gatudo]

    if @nen_gatudo.nil?
      attendance_years = Date.today
    else
      attendance_years = Date.new(@nen_gatudo[0..3].to_i, @nen_gatudo[4..-1].to_i, 1)
    end

    @nendo = get_nendo(attendance_years)
    @gatudo = get_gatudo(attendance_years)
    @project = get_project
    
    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @others = current_user.attendance_others

    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_attendances_path(format: :pdf, debug: 1, nen_gatudo: @nen_gatudo)}
      format.pdf do
        render pdf: '勤務状況報告書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  # 勤怠締め処理
  #
  #
  def freeze

    ActiveRecord::Base.transaction do

      # 今月分の締めを実施
      init
      @attendances.update_all(["freezed = ?",true])

      # 来月月分の勤怠情報を作成
      init true
      create_attendances true
    end

    redirect_to attendances_path, notice: '勤怠の締め処理を完了しました。'

  rescue => e
    render :index, notice: '勤怠締め処理に失敗しました。'
  end

  # 勤怠締め取消
  #
  #
  def unfreeze

    ActiveRecord::Base.transaction do
      init
      @attendances.update_all(["freezed = ?",false])
    end
    redirect_to attendances_path, notice: '勤怠の締め処理を取り消しました。'

  rescue => e
    render :index, notice: '勤怠締めの取り消し処理に失敗しました。'
  end

  # ------------------------------------------------------------------------------------------------------------------------
  private

  # 勤怠日付の初期化
  #
  #
  def init(freezed=false)

    unless session[:years].blank?
      @selected_nen_gatudo = session[:years]
    end
    
    if changed_attendance_years?
      @selected_nen_gatudo = params[:attendance][:nen_gatudo]
      session[:years] = params[:attendance][:nen_gatudo]
    end

    

    @attendance_years = get_attendance_years(params[:attendance], freezed)
    # @attendance_years = Date.new(2014, 2, 20)
    
    @nendo = get_nendo(@attendance_years)
    @gatudo = get_gatudo(@attendance_years)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    
    # if current_user.kinmu_patterns.first.nil?
    #   flash.now[:alert] = '勤務パターンを登録して下さい。'
    #   return false
    # end
  end

  # 勤怠情報の作成
  # 事前にinitにより対象年月を確定しておく必要あり
  #
  def create_attendances(freezed=false)
    
    if @attendances.exists?
      @freezed = @attendances.first.freezed
      create_attendance_years freezed
      return
    end
      
    target_date = Date.new(@attendance_years.year, get_month(@attendance_years), 16)
    end_attendance_date = target_date.months_since(1)

    
    while target_date != end_attendance_date

      @attendance = current_user.attendances.build
        
      @attendance[:attendance_date] = target_date
      @attendance[:year] = @nendo
      @attendance[:month] = @gatudo

      @attendance[:wday] = target_date.wday

      if holiday?(target_date)
        @attendance[:holiday] = "1"
      elsif ! current_user.kinmu_patterns.first.nil?
        @attendance[:pattern] = current_user.kinmu_patterns.first.code
        @attendance[:start_time] = current_user.kinmu_patterns.first.start_time
        @attendance[:end_time] = current_user.kinmu_patterns.first.end_time
        @attendance[:work_time] = current_user.kinmu_patterns.first.work_time
        @attendance[:holiday] = "0"

      end

      if @attendance.save
        @attendances << @attendance
        target_date = target_date.tomorrow
      else
        break
      end
    end

    @freezed = @attendances.first.freezed

    create_attendance_years freezed
  end

  # 
  #
  #
  def create_attendance_years(freezed=false)
    @nen_gatudo = current_user.attendances.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

    if freezed
      logger.debug("FREEZED:" + session[:years].to_s)
      temp = session[:years]
      
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
      next_years = years.months_since(1)
      
      @selected_nen_gatudo = "#{next_years.year}#{next_years.month}"
      session[:years] = @selected_nen_gatudo
    end
  end

  # 
  #
  #
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # 
  #
  #
  def attendance_params
    params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
      :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
      :break_time, :kouzyo_time, :work_time, :remarks, :user_id)
  end

  # 対象日付の月度を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の月度
  def get_gatudo(target_date)
    gatudo = target_date.month

    if target_date.day > 15
      gatudo = target_date.months_since(1).month
    end

    gatudo
  end

  # 対象日付の年度を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の年度
  def get_nendo(target_date)
    nendo = target_date.year

    if target_date.month == 12 and target_date.day > 15
      nendo = target_date.years_since(1).year
    end

    nendo
  end

  # 対象日付の月を返す
  # 対象日付の日が15日以前の場合に先月の月を返す。そうでない場合は当月の月を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の月
  def get_month(target_date)
    month = target_date.month

    if target_date.day < 16
      month = target_date.months_ago(1).month
    end

    month
  end

  # 休日かどうかを判定する
  # @return [Boolean] 対象日が休日の場合はtrueを返す。そうでない場合はfalseを返す
  def holiday?(target_date)
    target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
  end

  # 画面の対象年月が変更されたどうかを判定する
  # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def changed_attendance_years?
    return ! params[:attendance].nil?
  end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   日が16日以降の場合は翌月日付を返し、そうでない場合は本日日付を返す
  # 対象年月が変更されていない場合
  #   本日日付を返す
  # 対象年月が変更された場合
  #   対象年月初日の日付を返す
  # 締め取り消し処理の場合
  # @return [Date] 対象勤怠日付
  def get_attendance_years(attendance, freezed=false)
    
    unless session[:years].blank?
      logger.debug("aiueo" + session[:years].to_s)
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
    else
      temp = current_user.attendances.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
      if temp.exists?
        logger.debug("★★★★★★2")
        years = Date.new(temp.first.year.to_i, temp.first.month.to_i, 1)
      else
        logger.debug("★★★★★★3")
        years = Date.today
      end
    end

    if freezed
      logger.debug("★★★★★★4")
      years.months_since(1)
    else
      logger.debug("★★★★★★5")
      years
    end
      
    # elsif ! changed_attendance_years?
      
    #   temp = current_user.attendances.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
    #   if temp.exists?
    #     temp.each do |t|
    #       logger.debug("SELCT_YEARS:" + temp.first.year + temp.first.month)
    #     end
        
    #     return Date.new(temp.first.year.to_i, temp.first.month.to_i, 1)
    #   else
    #     return Date.today
    #   end
      
    
    # end
  end

  # 勤怠その他を作成します
  # @return [AttendanceOthers] 勤怠その他
  def get_attendance_others_info
    others = current_user.attendance_others
    
    if ! others.exists?
      @other = current_user.attendance_others.build(summary:"課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
      
      if @other.save
        others << @other
      end

      @other = current_user.attendance_others.build(summary:"全体会")
      if @other.save
        others << @other
      end

      @other = current_user.attendance_others.build()
      if @other.save
        others << @other
      end
    end

    others
  end

end
