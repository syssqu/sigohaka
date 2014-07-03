# -*- coding: utf-8 -*-
class AttendancesController < PapersController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :input_attendance_time, :calculate]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index

    init

    # 勤務パターンは3個固定で作成するので存在しない場合は考慮しない。
    # if current_user.kinmu_patterns.first.nil?
    #   flash.now[:alert] = '勤務パターンを登録して下さい。'
    #   return false
    # end
    
    create_attendances

    session[:years] = "#{@nendo}#{@gatudo}"
    logger.debug("session_years"+session[:years])
    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    @others = get_attendance_others_info

    @freezed = @attendances.first.freezed

    @status = "本人未確認"
    if @attendances.first.freezed
      @status = "凍結中"
    elsif @attendances.first.boss_approved
      @status = "上長承認済み"
    elsif @attendances.first.self_approved
      @status = "本人確認済み"
    end
  end

  #
  # 新規作成画面
  #
  def new
    @attendance = Attendance.new
  end

  #
  # 新規登録処理
  #
  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to attendances_path, notice: '登録しました。'
    else
      render :new
    end
  end

  #
  # 編集画面
  #
  def edit
    temp = current_user.kinmu_patterns.where("start_time is not null and end_time is not null")
    @pattern = temp.collect do |k|
      [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.code]
    end

    @pattern << [" * 定例外勤務(休出 or シフト)", 4]
  end

  #
  # 更新処理
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

  #
  # データ初期化処理
  # 対象年月の勤怠情報を勤務パターンをベースに再作成する
  #
  def init_attendances
    init

    sql = "pattern=?,start_time=?,end_time=?,byouketu=?,kekkin=?,hankekkin=?," +
      "tikoku=?,soutai=?,gaisyutu=?,tokkyuu=?,furikyuu=?,yuukyuu=?,syuttyou=?,over_time=?," +
      "holiday_time=?,midnight_time=?,break_time=?,kouzyo_time=?,work_time=?,remarks=?"

    ActiveRecord::Base.transaction do

      # 休日でない場合は勤務パターンをベースに値を設定
      @attendances.where("holiday = '0'").update_all([sql,
          current_user.kinmu_patterns.first.code,
          current_user.kinmu_patterns.first.start_time,
          current_user.kinmu_patterns.first.end_time,
          false,false,false,false,false,false,false,
          false,false,false,0.00, 0.00, 0.00, 0.00, 0.00,
          current_user.kinmu_patterns.first.work_time,nil])

      # 休日は全て空白に設定
      @attendances.where("holiday = '1'").update_all([sql,
          "","","",false,false,false,false,false,false,
          false,false,false,false,0.00, 0.00, 0.00, 0.00, 0.00, 0.00,nil])
    end

    redirect_to attendances_path, notice: '勤怠データを初期化しました。'
 
  rescue => e
    render :index, notice: '勤怠データの初期化に失敗しました。'
  end

  #
  # 勤務パターンが変更された際に出退勤時刻を変更する
  # 編集画面にて呼び出される
  #
  def input_attendance_time

    # @pattern = KinmuPattern.find_by(id: params[:pattern])
    @pattern = current_user.kinmu_patterns.find_by(code: params[:pattern])
    @time_blank = false

    if @pattern.nil?
      @time_blank = true
    else
      @attendance.start_time = @pattern.start_time
      @attendance.end_time = @pattern.end_time
    end
  end

  #
  # 自動計算処理
  # 勤怠パターンと出退勤時刻から遅刻や実働時間を自動計算する
  # 編集画面にて呼び出される
  #
  def calculate
    
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    @pattern = current_user.kinmu_patterns.find_by(code: params[:pattern])

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
  # 印刷画面
  #
  def print_proc

    years = session[:years]

    if years.nil?
      attendance_years = Date.today
    else
      attendance_years = Date.new(years[0..3].to_i, years[4..-1].to_i, 1)
    end

    @nendo = get_nendo(attendance_years)
    @gatudo = get_gatudo(attendance_years)
    @project = get_project
    
    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @others = current_user.attendance_others

    @title = '勤務状況報告書'
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @attendances.update_all(["self_approved = ?",true])

    init true
    create_attendances true
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @attendances.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @attendances.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @attendances.update_all(["boss_approved = ?",false])
  end

  # ------------------------------------------------------------------------------------------------------------------------
  private

  #
  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_attendance_years?
      session[:years] = params[:paper][:years]
    end

    @attendance_years = get_years(current_user.attendances, freezed)
    
    @nendo = get_nendo(@attendance_years)
    @gatudo = get_gatudo(@attendance_years)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
  end

  #
  # 勤怠情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_attendances(freezed=false)
    
    if @attendances.exists?
      @freezed = @attendances.first.freezed
      create_years_collection current_user.attendances, freezed
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
    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    create_years_collection current_user.attendances, freezed
  end

  #
  # Attendanceインスタンスを取得
  # :show, :edit, :update, :destroy, :input_attendance_time, :calculateにて呼び出す
  #
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # 
  # Strong Parameters
  #
  def attendance_params
    params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
      :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
      :break_time, :kouzyo_time, :work_time, :remarks, :user_id, :hankyuu, :holiday)
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
  # @param [Date] target_date 対象日付
  # @return [Boolean] 対象日が休日の場合はtrueを返す。そうでない場合はfalseを返す
  def holiday?(target_date)
    target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
  end

  # 画面の対象年月が変更されたどうかを判定する
  # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def changed_attendance_years?
    return ! params[:paper].nil?
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
