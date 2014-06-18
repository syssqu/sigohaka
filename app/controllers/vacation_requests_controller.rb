class VacationRequestsController < ApplicationController
  before_action :set_vacation_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /vacation_requests
  # GET /vacation_requests.json
  def index
    @vacation_requests = current_user.vacation_requests.all
    # VacationRequest.all
    # @vacation_request  = current_user.vacation_requests.all
  end

  # GET /vacation_requests/1
  # GET /vacation_requests/1.json
  def show
    @vacation_requests = current_user.vacation_requests.find(params[:id])
  end

  # GET /vacation_requests/new
  def new
    @vacation_request = current_user.vacation_requests.build
  end

  # GET /vacation_requests/1/edit
  def edit
  end

  # POST /vacation_requests
  # POST /vacation_requests.json
  def create
    @vacation_request = current_user.vacation_requests.build(vacation_request_params)

    respond_to do |format|
      if @vacation_request.save
        format.html { redirect_to @vacation_request, notice: '休暇届を作成しました' }
        format.json { render :show, status: :created, location: @vacation_request }
      else
        format.html { render :new }
        format.json { render json: @vacation_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacation_requests/1
  # PATCH/PUT /vacation_requests/1.json
  def update
    respond_to do |format|
      if @vacation_request.update(vacation_request_params)
        format.html { redirect_to @vacation_request, notice: '休暇届を更新しました' }
        format.json { render :show, status: :ok, location: @vacation_request }
      else
        format.html { render :edit }
        format.json { render json: @vacation_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacation_requests/1
  # DELETE /vacation_requests/1.json
  def destroy
    @vacation_request.destroy
    respond_to do |format|
      format.html { redirect_to vacation_requests_url, notice: '休暇届を削除しました' }
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
    @vacation_requests = VacationRequest.all
    @vacation_requests = current_user.vacation_requests.all
    @project = current_user.projects.find_by(active: true)
    @date=@vacation_requests.maximum(:updated_at ,:include)

    @vacation_request = current_user.vacation_requests.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    respond_to do |format|

      format.html { redirect_to print_vacation_requests_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '休暇届',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacation_request
      @vacation_request = VacationRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacation_request_params
      params.require(:vacation_request).permit(:user_id, :start_date, :end_date, :term, :category, :reason, :note, :year, :month)
    end

end
