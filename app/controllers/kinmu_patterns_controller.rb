# -*- coding: utf-8 -*-
class KinmuPatternsController < PapersController
  before_action :set_kinmu_pattern, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    logger.info("kinmu_patterns_controller::index")

    init

    # ヘッダー情報
    @years = create_years_collection view_context.target_user.kinmu_patterns # 対象年月リスト
    @users = create_users_collection                                         # 対象ユーザーリスト


  end

  def show
  end

  def new
    @kinmu_pattern = target_user.kinmu_patterns.build
  end

  def edit
  end

  def create
    @kinmu_pattern = target_user.kinmu_patterns.build(kinmu_pattern_params)

    if @kinmu_pattern.save
      redirect_to @kinmu_pattern, notice: '勤務パターンを作成しました'
    else
      render :new
    end
  end

  def update
    if @kinmu_pattern.update(kinmu_pattern_params)
      redirect_to kinmu_patterns_path, notic: '勤務パターンを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @kinmu_pattern.destroy
    redirect_to kinmu_patterns_url, notice: '勤務パターンを削除しました'
  end


  def init(freezed=false)
    logger.info("kinmu_patterns_controller::init")

    super(view_context.target_user.attendances, freezed)

    Rails.logger.debug("a- : #{@nendo.to_s} ")
    # 勤務パターン取得
    @kinmu_patterns = view_context.target_user.kinmu_patterns.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

  end

  #
  # 勤務パターン作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
#  def create_kinmu_patterns(freezed=false)

#    logger.info("create_kinmu_patterns")

  #  target_date = Date.new( YearsController.get_nendo(@target_years), YearsController.get_month(@target_years), 16)

    # 定例外勤務以外を取得
  #  @kinmu_patterns = view_context.target_user.kinmu_patterns.where("code <> '*'")

    # 対象年月を取得
  #  @kinmu_patterns = view_context.target_user.kinmu_patterns.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

  #  @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
#  end



  private
    def set_kinmu_pattern
      @kinmu_pattern = KinmuPattern.find(params[:id])
    end

    def kinmu_pattern_params
      params.require(:kinmu_pattern).permit(:code, :start_time, :end_time, :break_time, :midnight_break_time, :work_time, :shift, :user_id, :year, :month)
    end


end
