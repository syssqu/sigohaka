class StampingsController < PapersController
  def index

    logger.info("stampings_controller::index")

    @user_name = "#{view_context.target_user.family_name} #{view_context.target_user.first_name}"
  end

  #
  # 勤怠日付の初期化
  # 勤怠年月、勤怠情報、年度、月度の取得
  #
  def init(freezed=false)

    logger.debug("stampings_controller::init")

    super(view_context.target_user.attendances, freezed)

    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
  end
end
