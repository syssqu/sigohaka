class TransportationExpressesController < ApplicationController
  before_action :set_transportation_express, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /transportation_expresses
  # GET /transportation_expresses.json
  def index
    @transportation_expresses = TransportationExpress.all
    @transportation_express=current_user.transportation_expresses.all
    @project = current_user.projects.find_by(active: true)

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
    @date=@transportation_express.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end
  end

  # GET /transportation_expresses/1
  # GET /transportation_expresses/1.json
  def show
  end

  # GET /transportation_expresses/new
  def new
    @transportation_express = current_user.transportation_expresses.build
  end

  def transportation_confirm 
    @transportation_express = current_user.transportation_expresses.build(transportation_express_params)
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
    @transportation_expresses = TransportationExpress.all
    @transportation_expresses = current_user.transportation_expresses.all
    @project = current_user.projects.find_by(active: true)
    @sum = session[:sum] #交通費の合計金額表示
    @date=@transportation_expresses.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end
    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_transportation_expresses_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '交通費精算書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  # GET /transportation_expresses/1/edit
  def edit
  end

  # POST /transportation_expresses
  # POST /transportation_expresses.json
  def create
    @transportation_express = current_user.transportation_expresses.build(transportation_express_params)

    respond_to do |format|
      if @transportation_express.save
        format.html { redirect_to @transportation_express, notice: 'Transportation express was successfully created.' }
        format.json { render :show, status: :created, location: @transportation_express }
      else
        format.html { render :new }
        format.json { render json: @transportation_express.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transportation_expresses/1
  # PATCH/PUT /transportation_expresses/1.json
  def update
    respond_to do |format|
      if @transportation_express.update(transportation_express_params)
        format.html { redirect_to @transportation_express, notice: 'Transportation express was successfully updated.' }
        format.json { render :show, status: :ok, location: @transportation_express }
      else
        format.html { render :edit }
        format.json { render json: @transportation_express.errors, status: :unprocessable_entity }
      end
    end
    session[:date] = @transportation_express.updated_at
  end

  # DELETE /transportation_expresses/1
  # DELETE /transportation_expresses/1.json
  def destroy
    @transportation_express.destroy
    respond_to do |format|
      format.html { redirect_to transportation_expresses_url, notice: 'Transportation express was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transportation_express
      @transportation_express = TransportationExpress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transportation_express_params
      params.require(:transportation_express).permit(:user_id, :koutu_date, :destination, :route, :transport, :money, :note, :sum, :year, :month)
    end
end
