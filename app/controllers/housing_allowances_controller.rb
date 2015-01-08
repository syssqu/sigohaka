class HousingAllowancesController < ApplicationController
  before_action :set_housing_allowance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /housing_allowances
  # GET /housing_allowances.json
  def index
    @housing_allowances = HousingAllowance.all
    @housing_allowance_date = current_user.housing_allowances.all
    @date=@housing_allowance_date.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    @housing_allowance = current_user.housing_allowances.first
    @project=current_user.projects.find_by(active: true)

    @sum=0
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
    
    # @date=Time.parse(session[:date])
  

  end

  # GET /housing_allowances/1
  # GET /housing_allowances/1.json
  def show
  end

  # GET /housing_allowances/new
  def new
    @housing_allowance = current_user.housing_allowances.build
  end

  def print
     @nendo = Date.today.year
    
    if Date.today.month == 12 and Date.today.day > 15
      @nendo = Date.today.years_since(1).year
    end
    @housing_allowances = HousingAllowance.all
    @housing_allowances = current_user.housing_allowances.all
    @project = current_user.projects.find_by(active: true)
    @date=@housing_allowances.maximum(:updated_at,:include)
    if @date==nil
      @date=Date.today
    end
    @housing_allowances = current_user.housing_allowances.first

    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_housing_allowances_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '交通費精算書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end
  # GET /housing_allowances/1/edit
  def edit
  end

  # POST /housing_allowances
  # POST /housing_allowances.json
  def create
    # @housing_allowance = HousingAllowance.new(housing_allowance_params)
    @housing_allowance =current_user.housing_allowances.build(housing_allowance_params)

    respond_to do |format|
      if @housing_allowance.save
        format.html { redirect_to @housing_allowance, notice: 'Housing allowance was successfully created.' }
        format.json { render :show, status: :created, location: @housing_allowance }
      else
        format.html { render :new }
        format.json { render json: @housing_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /housing_allowances/1
  # PATCH/PUT /housing_allowances/1.json
  def update
    respond_to do |format|
      if @housing_allowance.update(housing_allowance_params)
        format.html { redirect_to @housing_allowance, notice: 'Housing allowance was successfully updated.' }
        format.json { render :show, status: :ok, location: @housing_allowance }
      else
        format.html { render :edit }
        format.json { render json: @housing_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /housing_allowances/1
  # DELETE /housing_allowances/1.json
  def destroy
    @housing_allowance.destroy
    respond_to do |format|
      format.html { redirect_to housing_allowances_url, notice: 'Housing allowance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_housing_allowance
      @housing_allowance = HousingAllowance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def housing_allowance_params
      params.require(:housing_allowance).permit(:user_id, :year, :month, :reason, :reason_text, :housing_style, :housing_style_text, :agree_date_s, :agree_date_e, :spouse, :spouse_name, :spouse_other, :support, :support_name1, :support_name2, :money)
    end


    # =================================================================================================-
    #
  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_housing_allowance_years?
      session[:years] = params[:paper][:years]
    end

    @housing_allowance_years = get_years(current_user.housing_allowances, freezed)
    
    @nendo = get_nendo(@housing_allowance_years)
    @gatudo = get_gatudo(@housing_allowance_years)
    @project = get_project

    @housing_allowances = current_user.housing_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
 
  end
end
