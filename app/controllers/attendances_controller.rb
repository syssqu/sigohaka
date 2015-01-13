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

    set_freeze_info

    @status = "本人未確認"
    if @attendances.first.boss_approved
      @status = "上長承認済み"
    elsif @attendances.first.self_approved
      @status = "本人確認済み"
    end

    @be_self = view_context.be_self @attendances.first
  end

  def set_freeze_info

    logger.debug("凍結状態の取得")
    
    if view_context.be_self @attendances.first
      @freezed = @attendances.first.self_approved or @attendances.first.boss_approved
    else
      @freezed = @attendances.first.boss_approved
    end
    
    logger.debug("勤怠情報: " + @attendances.first.id.to_s + ", " + @attendances.first.year + ", " + @attendances.first.month + ", " + @attendances.first.self_approved.to_s + ", " + @attendances.first.boss_approved.to_s)
    logger.debug("凍結状態: " + @freezed.to_s)
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
      [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.id]
    end

    @pattern << [" * 定例外勤務(休出 or シフト)", 4]
  end

  #
  # 更新処理
  #
  def update
    @attendance.is_blank_start_time = false
    @attendance.is_blank_end_time = false

    if params[:attendance]['start_time'].blank?
      @attendance.is_blank_start_time = true
    end

    if params[:attendance]['end_time'].blank?
      @attendance.is_blank_end_time = true
    end
    
    if @attendance.update_attributes(attendance_params)
      redirect_to attendances_path, notice: '更新しました。'
    else

      temp = current_user.kinmu_patterns.where("start_time is not null and end_time is not null")
      @pattern = temp.collect do |k|
        [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.code]
      end

      @pattern << [" * 定例外勤務(休出 or シフト)", 4]
      
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
          current_user.kinmu_patterns.first.start_time.strftime("%_H:%M"),
          current_user.kinmu_patterns.first.end_time.strftime("%_H:%M"),
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

    temp_pattern = current_user.kinmu_patterns.find_by(code: params[:pattern])

    if temp_pattern.nil?
      @attendance.start_time = "";
      @attendance.end_time = "";
    else
      @attendance.start_time = temp_pattern.start_time.strftime("%_H:%M")
      @attendance.end_time = temp_pattern.end_time.strftime("%_H:%M")
    end

  end

  #
  # 自動計算処理
  # 勤怠パターンと出退勤時刻から遅刻や実働時間を自動計算する
  # 編集画面にて呼び出される
  #
  def calculate

    Rails.logger.info("自動計算処理")
    Rails.logger.info("PARAMS: #{params.inspect}")

    @attendance.init_time_info()

    if params[:pattern].blank? or params[:start_time].blank? or params[:end_time].blank?
      return
    end
    
    temp_pattern = current_user.kinmu_patterns.find(params[:pattern])

    Rails.logger.info("pattern_start_date: " + temp_pattern.start_time.to_s)
    Rails.logger.info("pattern_end_date: " + temp_pattern.end_time.to_s)

    logger.debug("画面入力値(出勤時刻)" + params[:start_time])
    logger.debug("画面入力値(退勤時刻)" + params[:end_time])

    # attendance_start_time = Time.local(temp_pattern.start_time.year, temp_pattern.start_time.month, temp_pattern.start_time.day, params[:start_time][0..1], params[:start_time][3..4], 0)
    # attendance_end_time = Time.local(temp_pattern.end_time.year, temp_pattern.end_time.month, temp_pattern.end_time.day, params[:end_time][0..1], params[:end_time][3..4], 0)

    @attendance.calculate(temp_pattern, params[:start_time], params[:end_time])
  end

  #
  # 印刷画面
  #
  def print_proc

    years = session[:years]

    if years.nil?
      attendance_years = Date.today
    else
      attendance_years = Date.new(years[0..3].to_i, years[4..5].to_i, 1)
    end

    @nendo = get_target_year(attendance_years)
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

    # 画面選択年月分の勤怠情報を本人確認済みにする
    init
    @attendances.update_all(["self_approved = ?",true])

    # 翌月分の勤怠情報を作成し画面に出力する
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
    
    @nendo = get_target_year(@attendance_years)
    @gatudo = get_gatudo(@attendance_years)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
  end

  #
  # 勤怠情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_attendances(freezed=false)
    
    if @attendances.exists?
      set_freeze_info
      
      create_years_collection current_user.attendances, freezed
      return
    end
      
    target_date = Date.new(get_nendo(@attendance_years), get_month(@attendance_years), 16)

    end_attendance_date = target_date.months_since(1)

    while target_date != end_attendance_date

      logger.debug("勤怠日: " + target_date.to_s)

      @attendance = current_user.attendances.build
        
      @attendance[:attendance_date] = target_date
      @attendance[:year] = @nendo
      @attendance[:month] = @gatudo

      @attendance[:wday] = target_date.wday

      if holiday?(target_date)
        @attendance[:holiday] = "1"
      elsif ! current_user.kinmu_patterns.first.nil?

        @attendance[:pattern] = current_user.kinmu_patterns.first.code
        @attendance[:start_time] = current_user.kinmu_patterns.first.start_time.strftime("%_H:%M")
        @attendance[:end_time] = current_user.kinmu_patterns.first.end_time.strftime("%_H:%M")
        @attendance[:work_time] = current_user.kinmu_patterns.first.work_time
        @attendance[:holiday] = "0"

      end

      if @attendance.save
        target_date = target_date.tomorrow
      else
        logger.debug("勤怠登録処理エラー")
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

  # 対象年を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の年度
  def get_target_year(target_date)
    year = target_date.year

    if target_date.month == 12 and target_date.day > 15
      year = target_date.next_year.year
    end

    year
  end

  # 対象年度を返す
  # @param [Date] target_date 対象日付
  # @return [Integer] 対象日付の年度
  def get_nendo(target_date)
    nendo = target_date.year

    if target_date.month >= 1 and target_date.month < 4
      nendo = target_date.prev_year.year
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
