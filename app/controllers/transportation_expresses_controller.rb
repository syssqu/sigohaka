class TransportationExpressesController < ApplicationController
  before_action :set_transportation_express, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /transportation_expresses
  # GET /transportation_expresses.json
  def index
    @transportation_expresses = TransportationExpress.all
    @transportation_express=current_user.transportation_expresses.all

    @sum=0
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
