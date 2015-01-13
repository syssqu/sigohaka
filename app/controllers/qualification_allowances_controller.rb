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

    # @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    # year_month_set = current_user.attendances.group('year, month')
    # @nengatudo_set = []
    # year_month_set.each do |year_month|
    #   # nengatudo = { key: year_month[:year] + "/" + year_month[:month], value: year_month[:year] + "年" + year_month[:month] + "月度"}
    #   # @nengatudo_set << nengatudo
    #   @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    # end
    @project = get_project
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
        format.html { redirect_to qualification_allowances_url, notice: '資格手当申請書を登録しました' }
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
        format.html { redirect_to qualification_allowances_url, notice: '資格手当申請書を更新しました' }
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
      format.html { redirect_to qualification_allowances_url, notice: '資格手当申請書を削除しました' }
      format.json { head :no_content }
    end
  end

  def print

    year = Date.today.year
    month = Date.today.month
    day = Date.today.day
    
    @nendo = Date.today.year
    @gatudo = Date.today.month

    if Date.today.month == 12 and Date.today.day > 15
      @nendo = Date.today.years_since(1).year
    end
    @qualification_allowances = QualificationAllowance.all
    @qualification_allowances = current_user.qualification_allowances.all
    @project = current_user.projects.find_by(active: true)
    @date = @qualification_allowances.maximum(:updated_at ,:include)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_qualification_allowance
      @qualification_allowance = QualificationAllowance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def qualification_allowance_params
      params.require(:qualification_allowance).permit(
        :user_id, :number, :item, :money, :get_date, :registration_no_alphabet,
        :registration_no_year, :registration_no_month, :registration_no_individual)
    end
end
