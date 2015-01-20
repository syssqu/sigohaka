class QualificationAllowancesController < ApplicationController
  before_action :set_qualification_allowance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @project = get_project
    @qualification_allowances = current_user.qualification_allowances.all
  end

  def show
    @qualification_allowances = current_user.qualification_allowances.find(params[:id])
  end

  def new
    @qualification_allowance = current_user.qualification_allowances.build
  end

  def edit
  end

  def create
    @qualification_allowance = current_user.qualification_allowances.build(qualification_allowance_params)

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
    def set_qualification_allowance
      @qualification_allowance = QualificationAllowance.find(params[:id])
    end

    def qualification_allowance_params
      params.require(:qualification_allowance).permit(
        :user_id, :number, :item, :money, :get_date, :registration_no_alphabet,
        :registration_no_year, :registration_no_month, :registration_no_individual)
    end
end
