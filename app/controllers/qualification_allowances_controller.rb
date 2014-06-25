class QualificationAllowancesController < ApplicationController
  before_action :set_qualification_allowance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /qualification_allowances
  # GET /qualification_allowances.json
  def index
    # @qualification_allowances = QualificationAllowance.all
    # processing_date = Date.today

    # @nendo = get_nendo(processing_date)
    # @gatudo = get_gatudo(processing_date)
    # @project = get_project

    # @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    # year_month_set = current_user.attendances.group('year, month')
    # @nengatudo_set = []
    # year_month_set.each do |year_month|
    #   # nengatudo = { key: year_month[:year] + "/" + year_month[:month], value: year_month[:year] + "年" + year_month[:month] + "月度"}
    #   # @nengatudo_set << nengatudo
    #   @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    # end

    @qualification_allowances = current_user.qualification_allowances.all
  end

  # GET /qualification_allowances/1
  # GET /qualification_allowances/1.json
  def show
    @qualification_allowances = current_user.qualification_allowances.find(params[:id])
  end

  # GET /qualification_allowances/new
  def new
    @qualification_allowance = current_user.qualification_allowances.build
    # @qualification_allowance = QualificationAllowance.new
  end

  # GET /qualification_allowances/1/edit
  def edit
  end

  # POST /qualification_allowances
  # POST /qualification_allowances.json
  def create
    @qualification_allowance = current_user.qualification_allowances.build(qualification_allowance_params)
    # @qualification_allowance = QualificationAllowance.new(qualification_allowance_params)

    respond_to do |format|
      if @qualification_allowance.save
        format.html { redirect_to @qualification_allowance, notice: '登録しました' }
        format.json { render :show, status: :created, location: @qualification_allowance }
      else
        format.html { render :new }
        format.json { render json: @qualification_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qualification_allowances/1
  # PATCH/PUT /qualification_allowances/1.json
  def update
    respond_to do |format|
      if @qualification_allowance.update(qualification_allowance_params)
        format.html { redirect_to @qualification_allowance, notice: '更新しました' }
        format.json { render :show, status: :ok, location: @qualification_allowance }
      else
        format.html { render :edit }
        format.json { render json: @qualification_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qualification_allowances/1
  # DELETE /qualification_allowances/1.json
  def destroy
    @qualification_allowance.destroy
    respond_to do |format|
      format.html { redirect_to qualification_allowances_url, notice: '削除しました' }
      format.json { head :no_content }
    end
  end

  def print

    year = Date.today.year
    month = Date.today.month
    day = Date.today.day
    
    @nendo = Date.today.year
    @gatudo = Date.today.month

    if Date.today.day < 16
      month = Date.today.months_ago(1).month
    end

    if Date.today.day > 15
      @gatudo = Date.today.months_since(1).month
    end

    if Date.today.month == 12 and Date.today.day > 15
      @nendo = Date.today.years_since(1).year
    end
    @qualification_allowances = QualificationAllowance.all
    @qualification_allowances = current_user.qualification_allowances.all
    @project = current_user.projects.find_by(active: true)
    @date=@qualification_allowances.maximum(:updated_at ,:include)

    @qualification_allowance = current_user.qualification_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    
    respond_to do |format|

      format.html { redirect_to print_qualification_allowances_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '資格手当申請書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  def item_search
    ichi=["ITストラテジスト"]
    ni=["システム監査技術者"]
    san=["システムアーキテクト"]
    si=["応用情報技術者"]
    go=["プロジェクトマネージャー"]
    roku=["ネットワーク・スペシャリスト"]
    nana=["データベーススペシャリスト"]
    hiach=["エンベンデッドシステムスペシャリスト"]
    ku=["情報セキュリティースペシャリスト"]
    jyu=["ITサービスマネーシャー"]
    jyuichi=["基本情報技術者"]
    jyuni=["ITパスポート"]

    query = request.raw_post

    case query
    when "A1" then
      params[:item]=A1
    when "A2" then
      params[:item]=A2
    when "A3" then
      params[:item]=A3
    when "A4" then
      params[:item]=A4
    when "A5" then
      params[:item]=A5
    when "A6" then
      params[:item]=A6
    when "A7" then
      params[:item]=A7
    when "A8" then
      params[:item]=A8
    when "A9" then
      params[:item]=A9
    when "A10" then
      params[:item]=A10
    when "A11" then
      params[:item]=A11
    when "A12" then
      params[:item]=A12
    else
      params[:item]=["異常です"]
    end

    render :partial=>"item"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_qualification_allowance
      @qualification_allowance = QualificationAllowance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def qualification_allowance_params
      params.require(:qualification_allowance).permit(:user_id, :number, :item, :money)
    end
end
