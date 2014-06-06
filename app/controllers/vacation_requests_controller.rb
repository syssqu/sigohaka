class VacationRequestsController < ApplicationController
  before_action :set_vacation_request, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:edit, :update, :destroy]
  # before_action :correct_user,   only: [:edit, :update, :destroy]
  # GET /vacation_requests
  # GET /vacation_requests.json
  def index
    @vacation_requests = VacationRequest.all
  end

  # GET /vacation_requests/1
  # GET /vacation_requests/1.json
  def show
  end

  # GET /vacation_requests/new
  def new
    @vacation_request = VacationRequest.new
  end

  # GET /vacation_requests/1/edit
  def edit
  end

  # POST /vacation_requests
  # POST /vacation_requests.json
  def create
    @vacation_request = VacationRequest.new(vacation_request_params)

    respond_to do |format|
      if @vacation_request.save
        format.html { redirect_to @vacation_request, notice: 'Vacation request was successfully created.' }
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
        format.html { redirect_to @vacation_request, notice: 'Vacation request was successfully updated.' }
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
      format.html { redirect_to vacation_requests_url, notice: 'Vacation request was successfully destroyed.' }
      format.json { head :no_content }
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

    def signed_in_user
      redirect_to root_url, notice: "Please sign in." unless signed_in?
    end
    
    # def correct_user
    #   @user = User.find(params[:id])
    #   redirect_to(root_path) unless current_user?(@user)
    # end
end
