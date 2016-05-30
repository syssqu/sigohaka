# -*- coding: utf-8 -*-
class KinmuPatternsController < PapersController
  before_action :set_kinmu_pattern, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    logger.info("kinmu_patterns_controller::index")

    init

    # 勤務パターンが対象年月に存在しない場合、新たに作成する
    unless @kinmu_patterns.exists?
      create_kinmu_patterns
    end

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
    # init
    # @kinmu_pattern = current_user.kinmu_patterns.build(kinmu_pattern_params)

    # @kinmu_pattern[:year] = @nendo
    # @kinmu_pattern[:month] = @gatudo
    if @kinmu_pattern.update(kinmu_pattern_params)
      redirect_to kinmu_patterns_path, notice: '勤務パターンを更新しました'
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


    # 勤務パターン取得
    @kinmu_patterns = view_context.target_user.kinmu_patterns.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)







    # 最初に生成された勤務パターンの日付を取得
    #@min_created = view_context.target_user.kinmu_patterns.group("user_id").pluck("MIN(created_at)")

    # 本人確認で書き換え?
    #checkout_month = "#{@nendo}/#{@gatudo+1}/15 23:59"

    # 表示する１～５の勤務パターンを取得
   # patterns_query = view_context.target_user.kinmu_patterns
    #                    .select("code, MAX(updated_at)")
    #                    .where("(updated_at < '#{checkout_month}') OR (updated_at > '#{checkout_month}' AND created_at < '#{checkout_month}')")
    #                    .group("code")
    # 勤務パターンのデータ取得
#    @ptnn = view_context.target_user.kinmu_patterns
  #                  .where("(code, updated_at) IN (#{patterns_query.to_sql})")
  #                  .order("code ASC")


    Rails.logger.debug("a- : #{@kinmu_patterns.to_a} ")
  end

  #
  # 勤務パターン作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_kinmu_patterns(freezed=false)

    logger.info("create_kinmu_patterns")


    if ! @kinmu_patterns.exists?
      (1..5).each do |num|
        @kinmu_pattern = current_user.kinmu_patterns.build

        # デフォルトの勤務パターン
        @kinmu_pattern[:code] = num.to_s
        if num == 1
          @kinmu_pattern[:start_time] = "9:00"
          @kinmu_pattern[:end_time] = "18:00"
          @kinmu_pattern[:break_time] = 1.00
          @kinmu_pattern[:work_time] = 8.00
        end
        @kinmu_pattern[:year] = @nendo
        @kinmu_pattern[:month] = @gatudo

        if ! @kinmu_pattern.save
          logger.debug("勤務パターン登録エラー")
          break
        end

      end
    end

  end

  #  target_date = Date.new( YearsController.get_nendo(@target_years), YearsController.get_month(@target_years), 16)

    # 定例外勤務以外を取得
  #  @kinmu_patterns = view_context.target_user.kinmu_patterns.where("code <> '*'")

#  end



  private
    def set_kinmu_pattern
      @kinmu_pattern = KinmuPattern.find(params[:id])
    end

    def kinmu_pattern_params
      params.require(:kinmu_pattern).permit(:code, :start_time, :end_time, :break_time, :midnight_break_time, :work_time, :shift, :user_id, :year, :month)
    end


end
