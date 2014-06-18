class CommutesController < ApplicationController
  before_action :set_commute, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /commutes
  # GET /commutes.json
  def index
    @commutes = Commute.all
    @commute=current_user.commutes.all
    @reasons=Reason.all
    @reason=current_user.reasons.first

    @project = current_user.projects.find_by(active: true)
  end

  # GET /commutes/1
  # GET /commutes/1.json
  def show
  end

  # GET /commutes/new
  def new
    @commute = Commute.new
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
    @commutes = TransportationExpress.all
    @commutes = current_user.commutes.all
    @project = current_user.projects.find_by(active: true)
    @sum = session[:sum] #交通費の合計金額表示
    # @date=@transportation_expresses.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    # if @date==nil                                                 #更新日時が空なら今日の日付を使用
    #   @date=Date.today
    # end
    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_commutes_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '交通費精算書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  # GET /commutes/1/edit
  def edit
  end

  # POST /commutes
  # POST /commutes.json
  def create
    # @commute = Commute.new(commute_params)
    @commute = current_user.commutes.build(commute_params)

    respond_to do |format|
      if @commute.save
        format.html { redirect_to @commute, notice: 'Commute was successfully created.' }
        format.json { render :show, status: :created, location: @commute }
      else
        format.html { render :new }
        format.json { render json: @commute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commutes/1
  # PATCH/PUT /commutes/1.json
  def update
    respond_to do |format|
      if @commute.update(commute_params)
        format.html { redirect_to @commute, notice: 'Commute was successfully updated.' }
        format.json { render :show, status: :ok, location: @commute }
      else
        format.html { render :edit }
        format.json { render json: @commute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commutes/1
  # DELETE /commutes/1.json
  def destroy
    @commute.destroy
    respond_to do |format|
      format.html { redirect_to commutes_url, notice: 'Commute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commute
      @commute = Commute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commute_params
      params.require(:commute).permit(:user_id, :year, :month, :reason, :reason_text, :transport, :segment1, :segment2, :money)
    end
end
