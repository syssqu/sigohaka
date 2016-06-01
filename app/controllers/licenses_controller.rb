class LicensesController < ApplicationController
  before_action :set_license, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /licenses
  # GET /licenses.json
  def index
    @licenses = current_user.licenses.all
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
  end

  # GET /licenses/new
  def new
    @license = License.new
  end

  # GET /licenses/1/edit
  def edit
  end

  # POST /licenses
  # POST /licenses.json
  def create
    @license = current_user.licenses.build(license_params)

    if @license.save
      redirect_to licenses_path, notice: '作成しました。'
    else
      render :new
    end
  end

  # PATCH/PUT /licenses/1
  # PATCH/PUT /licenses/1.json
  def update
    if @license.update(license_params)
      redirect_to licenses_path, notice: '更新しました。'
    else
      render :edit
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    @license.destroy
    redirect_to licenses_url, notice: '削除しました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_license
      @license = License.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def license_params
      params.require(:license).permit(:code, :name, :years, :user_id)
    end
end
