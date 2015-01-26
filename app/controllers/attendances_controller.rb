# -*- coding: utf-8 -*-
class AttendancesController < PapersController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :input_attendance_time, :calculate]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index
    
    logger.info("attendances_controller::index")
    
    init

    unless @attendances.exists?
      create_attendances
    end

    unless view_context.target_user.kintai_headers.exists?(year: @nendo.to_s,month: @gatudo.to_s)
      create_kintai_header
    end

    @years = create_years_collection view_context.target_user.attendances # 対象年月リスト 要修正
    @users = create_users_collection                                      # 対象ユーザーリスト

    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    @others = get_attendance_others_info

    set_freeze_info @attendances

    set_status @attendances

    @be_self = view_context.be_self @attendances.first
  end

  #
  # 印刷画面
  #
  def print_proc

    setBasicInfo
    
    @attendances = view_context.target_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
    @others = get_attendance_others_info
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)

    @title = '勤務状況報告書'
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
    temp = view_context.target_user.kinmu_patterns.where("start_time is not null and end_time is not null")
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

      temp = view_context.target_user.kinmu_patterns.where("start_time is not null and end_time is not null")
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
          view_context.target_user.kinmu_patterns.first.code,
          view_context.target_user.kinmu_patterns.first.start_time.strftime("%_H:%M"),
          view_context.target_user.kinmu_patterns.first.end_time.strftime("%_H:%M"),
          false,false,false,false,false,false,false,
          false,false,false,0.00, 0.00, 0.00, 0.00, 0.00,
          view_context.target_user.kinmu_patterns.first.work_time,nil])
      
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

    logger.debug("attendances_controller::input_attendance_time")
    
    temp_pattern = view_context.target_user.kinmu_patterns.find_by(code: params[:pattern])

    if temp_pattern.nil?
      @attendance.start_time = "";
      @attendance.end_time = "";
    else
      if temp_pattern.start_time.blank?
        @attendance.start_time = ""
      else
        @attendance.start_time = temp_pattern.start_time.strftime("%_H:%M")
      end

      if temp_pattern.end_time.blank?
        @attendance.end_time = ""
      else
        @attendance.end_time = temp_pattern.end_time.strftime("%_H:%M")
      end

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
    
    temp_pattern = view_context.target_user.kinmu_patterns.find(params[:pattern])

    Rails.logger.info("pattern_start_date: " + temp_pattern.start_time.to_s)
    Rails.logger.info("pattern_end_date: " + temp_pattern.end_time.to_s)

    logger.debug("画面入力値(出勤時刻)" + params[:start_time])
    logger.debug("画面入力値(退勤時刻)" + params[:end_time])

    # attendance_start_time = Time.local(temp_pattern.start_time.year, temp_pattern.start_time.month, temp_pattern.start_time.day, params[:start_time][0..1], params[:start_time][3..4], 0)
    # attendance_end_time = Time.local(temp_pattern.end_time.year, temp_pattern.end_time.month, temp_pattern.end_time.day, params[:end_time][0..1], params[:end_time][3..4], 0)

    @attendance.calculate(temp_pattern, params[:start_time], params[:end_time])
  end

  #
  # 本人確認処理
  #
  def check_proc

    # 画面選択年月分の勤怠情報を本人確認済みにする
    init
    @attendances.update_all(["self_approved = ?",true])

    # タイムラインへメッセージを投稿
    posting_check_proc("勤怠状況報告書")

    # 翌月分の勤怠情報を作成し画面に出力する
    init true
    create_attendances
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @attendances.update_all(["self_approved = ?",false])

    # タイムラインへメッセージを投稿
    posting_check_proc("勤怠状況報告書")
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @attendances.update_all(["boss_approved = ?",true])

    temp_user = @attendances.first.user

    # タイムラインへメッセージを投稿
    posting_approve_proc("勤怠状況報告書", temp_user)
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @attendances.update_all(["boss_approved = ?",false])

    temp_user = @attendances.first.user
    
    # タイムラインへメッセージを投稿
    posting_cancel_approve_proc("勤怠状況報告書", temp_user)
  end

  # ------------------------------------------------------------------------------------------------------------------------
  private

  #
  # 勤怠日付の初期化
  # 勤怠年月、勤怠情報、年度、月度の取得
  #
  def init(freezed=false)

    logger.debug("attendances_controller::init")

    super(view_context.target_user.attendances, freezed)

    @attendances = view_context.target_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
  end

  #
  # 勤怠情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_attendances

    logger.debug("attendances_controller::create_attendances")
      
    target_date = Date.new( YearsController.get_nendo(@target_years), YearsController.get_month(@target_years), 16)

    end_attendance_date = target_date.months_since(1)

    while target_date != end_attendance_date

      logger.debug("勤怠日: " + target_date.to_s)

      @attendance = view_context.target_user.attendances.build
        
      @attendance[:attendance_date] = target_date
      @attendance[:year] = @nendo
      @attendance[:month] = @gatudo

      @attendance[:wday] = target_date.wday

      if YearsController.holiday?(target_date)
        @attendance[:holiday] = "1"
      elsif ! view_context.target_user.kinmu_patterns.first.nil?

        @attendance[:pattern] = view_context.target_user.kinmu_patterns.first.code
        @attendance[:start_time] = view_context.target_user.kinmu_patterns.first.start_time.strftime("%_H:%M")
        @attendance[:end_time] = view_context.target_user.kinmu_patterns.first.end_time.strftime("%_H:%M")
        @attendance[:work_time] = view_context.target_user.kinmu_patterns.first.work_time
        @attendance[:holiday] = "0"

      end

      if @attendance.save
        target_date = target_date.tomorrow
      else
        logger.debug("勤怠登録処理エラー")
        break
      end
    end

    @attendances = view_context.target_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
  end

  #
  # Attendanceインスタンスを取得
  # :show, :edit, :update, :destroy, :input_attendance_time, :calculateにて呼び出す
  #
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # 勤怠その他を作成します
  # @return [AttendanceOthers] 勤怠その他
  def get_attendance_others_info

    others = view_context.target_user.attendance_others.where(year: @nendo, month: @gatudo).order(:id)
    
    if ! others.exists?
      @other = view_context.target_user.attendance_others.build(summary:"課会", year: @nendo, month: @gatudo)
      
      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      @other = view_context.target_user.attendance_others.build(summary:"全体会", year: @nendo, month: @gatudo)
      
      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      @other = view_context.target_user.attendance_others.build(year: @nendo, month: @gatudo)
      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      others = view_context.target_user.attendance_others().where(year: @nendo, month: @gatudo).order(:id)
    end

    others
  end

  # 
  # Strong Parameters
  #
  def attendance_params
    params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
      :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
      :break_time, :kouzyo_time, :work_time, :remarks, :user_id, :hankyuu, :holiday)
  end

end
