
class SummaryAttendancesController < ApplicationController
  before_action :set_summary_attendance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /summary_attendances
  # GET /summary_attendances.json
  def init
    if changed_attendance_years?
      @selected_nen_gatudo = params[:paper][:nen_gatudo]
    end

    @attendance_years = get_attendance_years(params[:paper])
    # @attendance_years = Date.new(2014, 2, 20)
    @nendo = get_nendo(@attendance_years)
    @gatudo = get_gatudo(@attendance_years)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @nen_gatudo = current_user.attendances.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id desc")

    if current_user.kinmu_patterns.first.nil?
      flash.now[:alert] = '勤務パターンを登録して下さい。'
      return
    end
  end

  def index

    init

    @summary_attendances = SummaryAttendance.all
    if current_user.role == "admin"
      @user = User.all
    elsif current_user.role == "manager"
      @user = User.where( section_id:current_user.section_id)
    end
    # @summary_attendances = @user.summary_attendances
    # @summary_attendance = user.attendances.order
    @attendances = Attendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @over_sum=0
    @kinmu_max=0
    
    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    @others = get_attendance_others_info

  end

  # GET /summary_attendances/1
  # GET /summary_attendances/1.json
  def show
  end

  # GET /summary_attendances/new
  def new
    @summary_attendance = SummaryAttendance.new
  end

  # GET /summary_attendances/1/edit
  def edit
  end

  # POST /summary_attendances
  # POST /summary_attendances.json
  def create
    @summary_attendance = SummaryAttendance.new(summary_attendance_params)
    # @summary_attendance.user = User.find_by id: session[:user_id]
    respond_to do |format|
      if @summary_attendance.save
        format.html { redirect_to @summary_attendance, notice: 'Summary attendance was successfully created.' }
        format.json { render :show, status: :created, location: @summary_attendance }
      else
        format.html { render :new }
        format.json { render json: @summary_attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /summary_attendances/1
  # PATCH/PUT /summary_attendances/1.json
  def update
    respond_to do |format|
      if @summary_attendance.update(summary_attendance_params)
        format.html { redirect_to @summary_attendance, notice: 'Summary attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @summary_attendance }
      else
        format.html { render :edit }
        format.json { render json: @summary_attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  def calculate
    
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    @attendance = Attendance.find(params[:id])
    @pattern = KinmuPattern.find(params[:pattern])

    
    params[:start_time_hour]
    params[:start_time_minute]
    params[:end_time_hour]
    params[:end_time_minute]


    Rails.logger.info("pattern_start_date: " + @pattern.start_time.to_s)
    Rails.logger.info("input_start_date: " + @pattern.start_time.to_s)

    
    @attendance.over_time = 0
    

  end

  def print

    @nen_gatudo = params[:nen_gatudo]

    if @nen_gatudo.nil?
      attendance_years = Date.today
    else
      attendance_years = Date.new(@nen_gatudo[0..3].to_i, @nen_gatudo[4..-1].to_i, 1)
    end

    @nendo = get_nendo(attendance_years)
    @gatudo = get_gatudo(attendance_years)
    @project = get_project
    @summary_attendances = SummaryAttendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @attendances = Attendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @others = current_user.attendance_others
    @user = User.all
    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_summary_attendances_path(format: :pdf, debug: 1, nen_gatudo: @nen_gatudo)}
      format.pdf do
        render pdf: '勤務状況報告書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end


  # DELETE /summary_attendances/1
  # DELETE /summary_attendances/1.json
  def destroy
    @summary_attendance.destroy
    respond_to do |format|
      format.html { redirect_to summary_attendances_url, notice: 'Summary attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def data_make
    # 勤務状況集計表用データ を作成
    # @nendo = get_nendo(@attendance_years)
    # @gatudo = get_gatudo(@attendance_years)
    init
    @summary_attendance = current_user.summary_attendances.build
    @summary_attendance[:year] = @nendo
    @summary_attendance[:month] = @gatudo
    if @summary_attendance.save

      redirect_to attendances_path, notice: '勤務状況を登録しました'
    end
  end

  private
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def attendance_params
      params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
        :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
        :break_time, :kouzyo_time, :work_time, :remarks, :user_id)
    end

    def get_gatudo(target_date)
      gatudo = target_date.month

      if target_date.day > 15
        gatudo = target_date.months_since(1).month
      end

      gatudo
    end

    def get_nendo(target_date)
      nendo = target_date.year

      if target_date.month == 12 and target_date.day > 15
        nendo = target_date.years_since(1).year
      end

      nendo
    end

    def get_month(target_date)
      month = target_date.month

      if target_date.day < 16
        month = target_date.months_ago(1).month
      end

      month
    end

    def holiday?(target_date)
      target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
    end

    def changed_attendance_years?
      nen_gatudo = params[:paper]
      return ! nen_gatudo.nil?
    end

    def get_attendance_years(nen_gatudo)
    
      if ! changed_attendance_years?
        return Date.today
      else
        temp = nen_gatudo[:nen_gatudo]
        return Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
      end
    end
    def get_attendance_others_info
      others = current_user.attendance_others
      
      if ! others.exists?
        @other = current_user.attendance_others.build(summary:"課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
        
        if @other.save
          others << @other
        end

        @other = current_user.attendance_others.build(summary:"全体会")
        if @other.save
          others << @other
        end

        @other = current_user.attendance_others.build()
        if @other.save
          others << @other
        end
      end

      others
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_summary_attendance
      logger.debug("DEBUNG_INFO" + params[:id].to_s)
      @summary_attendance = SummaryAttendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def summary_attendance_params
      params.require(:summary_attendance).permit(:user_id, :year, :month, :previous_m, :present_m, :vacation, :half_holiday, :note)
    end


end
