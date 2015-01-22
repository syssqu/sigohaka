# -*- coding: utf-8 -*-
class AttendancesController < PapersController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy, :input_attendance_time, :calculate]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index
    logger.debug("attendances_controller::index")

    # 勤怠年月、勤怠情報、年度、月度の取得
    init

    unless @attendances.exists?
      create_attendances
    end

    @years = create_years_collection view_context.target_user.attendances # 対象年月リスト 要修正
    @users = create_users_collection                                      # 対象ユーザーリスト

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

  #
  # 印刷画面
  #
  def print_proc

    if session[:years].nil?
      redirect_to :index
    end

    @nendo = session[:years][0..3].to_i
    @gatudo = session[:years][4..5].to_i
    @project = get_project
    
    @attendances = view_context.target_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
    @others = get_attendance_others_info
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)

    @title = '勤務状況報告書'
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
    temp = view_context.target_user.kinmu_patterns.where("start_time is not null and end_time is not null")
    @pattern = temp.collect do |k|
      [ "#{k.code} 出勤: #{k.start_time.strftime('%_H:%M')} 退勤: #{k.end_time.strftime('%_H:%M')} 休憩: #{k.break_time}h 実働: #{k.work_time}h ", k.id]
    end

    @pattern << [" * 定例外勤務(休出 or シフト)", 4]
  end

  #
  # 更新処理
  #
  def edit_header
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: session[:years][0..3], month: session[:years][4..5])
  end

  #
  # 更新処理
  #
  def update_header
    logger.debug("attendances_controller::header_update")
    
    @kintai_header = KintaiHeader.find(params[:kintai_header][:id])
    
    if @kintai_header.update_attributes(header_params)
      logger.debug("success")
      redirect_to attendances_path, notice: '更新しました。'
    else
      logger.debug("faile")
      render :header_edit
    end
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

    temp_pattern = view_context.target_user.kinmu_patterns.find_by(code: params[:pattern])

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
    
    # 対象年月を翌月に設定する
    temp_years = YearsController.next_years(session[:years])
    unless temp_years.blank?
      session[:years] = temp_years
    end
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

    # 対象年月
    if YearsController.changed_attendance_years?(params[:paper])
      session[:years] = params[:paper][:years]
    end
    
    # 対象ユーザー
    session[:target_user] ||= current_user.id
    if YearsController.changed_attendance_users?(params[:user])
      session[:target_user] = params[:user][:id]
    end

    @attendance_years = get_years(view_context.target_user.attendances, freezed)
    
    @nendo = YearsController.get_target_year(@attendance_years)
    @gatudo = YearsController.get_gatudo(@attendance_years)
    @project = get_project
    
    session[:years] ||= "#{@nendo}#{@gatudo}"

    @attendances = view_context.target_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).order("attendance_date")
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)

  end

  #
  # 勤怠情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_attendances

    logger.debug("attendances_controller::create_attendances")
      
    target_date = Date.new( YearsController.get_nendo(@attendance_years), YearsController.get_month(@attendance_years), 16)

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

    # ヘッダー情報(ユーザー名、所属、プロジェクト名)の登録
    kintai_header = view_context.target_user.kintai_headers.build
    kintai_header[:year] = @nendo
    kintai_header[:month] = @gatudo
    kintai_header[:user_name] = "#{view_context.target_user.family_name} #{view_context.target_user.first_name}"
    kintai_header[:section_name] = view_context.target_user.section.name unless view_context.target_user.section.blank?

    @project = get_project
    kintai_header[:project_name] = @project.summary unless @project.blank?
    unless kintai_header.save
      logger.debug("勤怠ヘッダ登録処理エラー")
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

  def header_params
    params.require(:kintai_header).permit(:user_name, :section_name, :project_name)
  end

end
