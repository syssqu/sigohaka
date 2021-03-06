# -*- coding: utf-8 -*-
#
# 勤務状況報告書用コントローラー
#
class AttendancesController < PapersController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :input_attendance_time, :calculate]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index

    logger.info("attendances_controller::index")

    init

    unless @kinmu_patterns.exists?
      create_kinmu_patterns
    end

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
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s, month: @gatudo.to_s)
    @kinmu_patterns = view_context.target_user.kinmu_patterns.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("code ASC")

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
    init
    temp = view_context.target_user.kinmu_patterns.where("start_time is not null and end_time is not null and (year = ? and month = ?)", @nendo.to_s, @gatudo.to_s).order("code ASC")
    @pattern = temp.collect do |k|
      [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.code]
    end

    @pattern << [" * 定例外勤務(休出 or シフト)", "※"]
  end

  #
  # 更新処理
  #
  def update
    init
    @attendance.is_blank_start_time = false
    @attendance.is_blank_end_time = false

    @attendance.is_negative_over_time = false
    @attendance.is_negative_holiday_time = false
    @attendance.is_negative_midnight_time = false
    @attendance.is_negative_break_time = false
    @attendance.is_negative_kouzyo_time = false
    @attendance.is_negative_work_time = false

    if params[:attendance]['start_time'].blank?
      @attendance.is_blank_start_time = true
    end

    if params[:attendance]['end_time'].blank?
      @attendance.is_blank_end_time = true
    end


    if params[:attendance]['over_time'].to_d < 0
      @attendance.is_negative_over_time = true
    end
    if params[:attendance]['holiday_time'].to_d < 0
      @attendance.is_negative_holiday_time = true
    end
    if params[:attendance]['midnight_time'].to_d < 0
      @attendance.is_negative_midnight_time = true
    end
    if params[:attendance]['break_time'].to_d < 0
      @attendance.is_negative_break_time = true
    end
    if params[:attendance]['kouzyo_time'].to_d < 0
      @attendance.is_negative_kouzyo_time = true
    end
    if params[:attendance]['work_time'].to_d < 0
      @attendance.is_negative_work_time = true
    end



    if @attendance.update_attributes(attendance_params)
      redirect_to attendances_path, notice: '更新しました。'
    else

      temp = view_context.target_user.kinmu_patterns.where("start_time is not null and end_time is not null and (year = ? and month = ?)", @nendo.to_s, @gatudo.to_s).order("code ASC")
      @pattern = temp.collect do |k|
        [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.code]
      end

      @pattern << [" * 定例外勤務(休出 or シフト)", "※"]

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
          @kinmu_patterns.first.code,
          @kinmu_patterns.first.start_time.strftime("%_H:%M"),
          @kinmu_patterns.first.end_time.strftime("%_H:%M"),
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
    init
    logger.debug("attendances_controller::input_attendance_time")

    temp_pattern = view_context.target_user.kinmu_patterns.where("year = ? and month = ? and code = ?", @nendo.to_s, @gatudo.to_s, params[:pattern]).first

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
    init

    Rails.logger.info("自動計算処理")
    Rails.logger.info("PARAMS: #{params.inspect}")

    @attendance.init_time_info()

    if params[:pattern].blank? or params[:start_time].blank? or params[:end_time].blank?
      return
    end

    temp_pattern = view_context.target_user.kinmu_patterns.where("year = ? and month = ? and code = ?", @nendo.to_s, @gatudo.to_s, params[:pattern]).first

    logger.debug("画面入力値(出勤時刻) #{params[:start_time]}")
    logger.debug("画面入力値(退勤時刻) #{params[:end_time]}")

    @attendance.calculate(temp_pattern , params[:start_time],params[:end_time])
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
    @kinmu_patterns = view_context.target_user.kinmu_patterns.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("code ASC")

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

        @attendance[:pattern] = @kinmu_patterns.first.code
        @attendance[:start_time] = @kinmu_patterns.first.start_time.strftime("%_H:%M")
        @attendance[:end_time] = @kinmu_patterns.first.end_time.strftime("%_H:%M")
        @attendance[:work_time] = @kinmu_patterns.first.work_time
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
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s, month: @gatudo.to_s)
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

    others = view_context.target_user.attendance_others.where(year: @nendo.to_s, month: @gatudo.to_s).order(:id)

    if ! others.exists?
      @other = view_context.target_user.attendance_others.build(summary:"課会", year: @nendo.to_s, month: @gatudo.to_s)

      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      @other = view_context.target_user.attendance_others.build(summary:"全体会", year: @nendo.to_s, month: @gatudo.to_s)

      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      @other = view_context.target_user.attendance_others.build(year: @nendo.to_s, month: @gatudo.to_s)
      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      @other = view_context.target_user.attendance_others.build(year: @nendo.to_s, month: @gatudo.to_s)
      unless @other.save
        logger.debug("勤怠(その他)登録エラー")
      end

      others = view_context.target_user.attendance_others().where(year: @nendo.to_s, month: @gatudo.to_s).order(:id)
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
