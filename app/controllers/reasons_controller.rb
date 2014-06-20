class ReasonsController < ApplicationController
  before_action :set_reason, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!
  def edit
  end

  def new
    @reason = Reason.new
  end

  def show
  end

  def create
    @reason = current_user.reasons.build(reason_params)

    respond_to do |format|
      if @reason.save
        format.html { redirect_to @reason, notice: 'Commute was successfully created.' }
        format.json { render :show, status: :created, location: @reason }
      else
        format.html { render :new }
        format.json { render json: @reason.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @reason.update(reason_params)
        format.html { redirect_to @reason, notice: 'Commute was successfully updated.' }
        format.json { render :show, status: :ok, location: @reason }
      else
        format.html { render :edit }
        format.json { render json: @reason.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_reason
    @reason = Reason.find_by_id(params[:id])
    unless @reason then
  # 0件のときの処理
      redirect_to commutes_path
    end
  end

  def reason_params
    params.require(:reason).permit(:user_id, :year, :month, :reason, :reason_text)
  end
end
