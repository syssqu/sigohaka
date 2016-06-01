class StampingsController < PapersController
  before_action :set_attendance, only: [:go_to_work]
  before_action :authenticate_user!

  def index
    logger.info("stampings_controller::index")

    init

    @user_name = "#{view_context.target_user.family_name} #{view_context.target_user.first_name}"
  end

  def go_to_work
    if params[:leave].nil? && @attendance.go_to_work
      flash[:error_message] = "すでに出勤されています。"
      redirect_to stampings_index_path
      return
    end

    if params[:leave] && @attendance.leave_work
      flash[:error_message] = "すでに退勤されています。"
      redirect_to stampings_index_path
      return
    end

    year = params["stamping"]["year"]
    month = params["stamping"]["month"]
    day = params["stamping"]["day"]
    hh = params["stamping"]["hh"]
    mm = sprintf("%02d", params["stamping"]["mm"])
    ss = params["stamping"]["ss"]

    time = "#{hh}:#{mm}"

    if params[:leave]
      if @attendance.update_columns(end_time: time, leave_work: true)
        flash[:notice_message] = "退勤しました。"
        redirect_to stampings_index_path
      end
    else
      if @attendance.update_columns(start_time: time, go_to_work: true)
        flash[:notice_message] = "出勤しました。"
        redirect_to stampings_index_path
      end
    end
  end

  #
  # 勤怠日付の初期化
  # 勤怠年月、勤怠情報、年度、月度の取得
  #
  def init(freezed=false)

    logger.debug("stampings_controller::init")

    super(view_context.target_user.attendances, freezed)
  end

  #
  # Attendanceインスタンスを取得
  # :show, :edit, :update, :destroy, :input_attendance_time, :calculateにて呼び出す
  #
  def set_attendance
    logger.debug("stampings_controller::set_attendance")
    init

    year = params["stamping"]["year"]
    month = params["stamping"]["month"]
    day = params["stamping"]["day"]
    hh = params["stamping"]["hh"]
    mm = params["stamping"]["mm"]
    ss = params["stamping"]["ss"]

    logger.debug(year + ":" + month + ":" + day + ":" + hh + ":" + mm + ":" + ss)

    @dateTime = Date.new(year.to_i, month.to_i, day.to_i)
    @attendance = Attendance.find_by(user_id: view_context.target_user.id, attendance_date: @dateTime)

    if @attendance.nil?
      create_attendances
    end

  end

  #
  # 勤怠情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_attendances

    logger.debug("stampings_controller::create_attendances")

    target_date = Date.new( YearsController.get_nendo(@dateTime), YearsController.get_month(@dateTime), 16)

    end_attendance_date = target_date.months_since(1)

    while target_date != end_attendance_date

      logger.debug("勤怠日: " + target_date.to_s)
      logger.debug("勤怠最終日: " + end_attendance_date.to_s)

      gatudo = YearsController.get_gatudo(target_date)
      nendo = YearsController.get_target_year(target_date)
      logger.debug("gatudo : " + gatudo.to_s)
      @attendance = view_context.target_user.attendances.build

      @attendance[:attendance_date] = target_date.to_s
      @attendance[:year] = nendo
      @attendance[:month] = gatudo

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

    # 勤怠情報作成後、再度現在の勤怠情報を取得
    @attendance = Attendance.find_by(user_id: view_context.target_user.id, attendance_date: @dateTime)
  end

  private
    #
    # Strong Parameters
    #
    def attendance_params
      params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
        :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
        :break_time, :kouzyo_time, :work_time, :remarks, :user_id, :hankyuu, :holiday, :go_to_work, :leave_work)
    end
end
