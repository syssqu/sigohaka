# -*- coding: utf-8 -*-

class SummaryAttendancesController < PapersController
  before_action :set_summary_attendance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /summary_attendances
  # GET /summary_attendances.json


  def index

    init


    session[:years] = "#{@nendo}#{@gatudo}"
    logger.debug("session_years"+session[:years])

    # 未実装
    # @status = "本人未確認"
    # if @attendances.first.boss_approved
    #   @status = "上長承認済み"
    # elsif @attendances.first.self_approved
    #   @status = "本人確認済み"
    # end

    create_summary_attendances
    # 合計出力用
    # @attendances = Attendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)


    @years = create_years_collection view_context.target_user.vacation_requests # 対象年月リスト 要修正


    set_freeze_info

    # TODO 課会などの実働時間は未使用
    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    # @others = get_attendance_others_info

  end



  def set_freeze_info

    # logger.debug("凍結状態の取得")

    # if view_context.be_self @attendances.first
    #   @freezed = @attendances.first.self_approved or @attendances.first.boss_approved
    # else
    #   @freezed = @attendances.first.boss_approved
    # end

    # logger.debug("勤怠情報: " + @attendances.first.id.to_s + ", " + @attendances.first.year + ", " + @attendances.first.month + ", " + @attendances.first.self_approved.to_s + ", " + @attendances.first.boss_approved.to_s)
    # logger.debug("凍結状態: " + @freezed.to_s)
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

  def print_proc

    years = session[:years]

    if years.nil?
      attendance_years = Date.today
    else
      attendance_years = Date.new(years[0..3].to_i, years[4..5].to_i, 1)
    end

    @nendo = get_nendo(attendance_years)
    @gatudo = get_gatudo(attendance_years)
    @project = get_project

    init

    # @summary_attendances = SummaryAttendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    # @attendances = Attendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @others = current_user.attendance_others
    # @user = User.all

    # @summary_attendances = user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    # @others = user.attendance_others

    @title = '勤務状況報告書'
  end

  #
  # 上長承認処理
  # 未実装
  def approve_proc
    init
    @summary_attendances.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  # 未実装
  def cancel_approval_proc
    init
    @summary_attendances.update_all(["boss_approved = ?",false])
  end

  # PATCH/PUT /summary_attendances/1
  # PATCH/PUT /summary_attendances/1.json
  def update
    respond_to do |format|
      if @summary_attendance.update(summary_attendance_params)
        format.html { redirect_to summary_attendances_url, notice: '項目を修正しました' }
        format.json { render :show, status: :ok, location: @summary_attendance }
      else
        format.html { render :edit }
        format.json { render json: @summary_attendance.errors, status: :unprocessable_entity }
      end
    end
  end



  # def print

  #   @nen_gatudo = params[:nen_gatudo]

  #   if @nen_gatudo.nil?
  #     attendance_years = Date.today
  #   else
  #     attendance_years = Date.new(@nen_gatudo[0..3].to_i, @nen_gatudo[4..5].to_i, 1)
  #   end

  #   @nendo = get_nendo(attendance_years)
  #   @gatudo = get_gatudo(attendance_years)
  #   @project = get_project
  #   @summary_attendances = SummaryAttendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
  #   @attendances = Attendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
  #   @others = current_user.attendance_others
  #   @user = User.all
  #   respond_to do |format|
  #     # format.html { redirect_to print_attendances_path(format: :pdf)}
  #     # format.pdf do
  #     #   render pdf: '勤務状況報告書',
  #     #          encoding: 'UTF-8',
  #     #          layout: 'pdf.html'
  #     format.html { redirect_to print_summary_attendances_path(format: :pdf, debug: 1, nen_gatudo: @nen_gatudo)}
  #     format.pdf do
  #       render pdf: '勤務状況報告書',
  #              encoding: 'UTF-8',
  #              layout: 'pdf.html',
  #              show_as_html: params[:debug].present?
  #     end
  #   end
  # end


  # DELETE /summary_attendances/1
  # DELETE /summary_attendances/1.json
  def destroy
    @summary_attendance.destroy
    respond_to do |format|
      format.html { redirect_to summary_attendances_url, notice: 'Summary attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  # 初期化
  def init(freezed=false)
    if changed_attendance_years?
      session[:years] = params[:paper][:years]
    end

    @attendance_years = get_years(current_user.attendances, freezed)
    # @attendance_years = Date.new(2014, 2, 20)
    @nendo = get_nendo(@attendance_years)
    @gatudo = get_gatudo(@attendance_years)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    # @nen_gatudo = current_user.attendances.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id desc")

    # if current_user.kinmu_patterns.first.nil?
    #   flash.now[:alert] = '勤務パターンを登録して下さい。'
    #   return
    # end

    # 総合計
    @byouketu_sum=0
    @kekkin_sum=0
    @hankekkin_sum=0
    @tikoku_sum=0
    @soutai_sum=0
    @gaisyutu_sum=0
    @furikyuu_sum=0
    @tokkyuu_sum=0
    @yuukyuu_sum=0
    @syuttyou_sum=0
    @over_time_sum=0
    @holiday_time_sum=0
    @midnight_time_sum=0
    @kouzyo_time_sum=0
    @previous_m_sum=0
    @present_m_sum=0
    @vacation_sum=0
    @half_holiday_sum=0
    @kinmu_sum=0
    @work_time_sum=0


     @summary_attendances = SummaryAttendance.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    if current_user.katagaki.role == "admin"
      @user = User.all
    elsif current_user.katagaki.role == "manager"
      @user = User.where( section_id:current_user.section_id)
    end
    # @summary_attendances = @user.summary_attendances
    # @summary_attendance = user.attendances.order


  end


  #
  # 勤怠集計情報の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_summary_attendances(freezed=false)
    if @user.exists?
      # summary_attendancesが存在しなければユーザー数分作成
      create_years_collection current_user.attendances, freezed
      if !@summary_attendances.exists?
        @user.each do |user|
          @summary_attendance = user.summary_attendances.build
          @summary_attendance[:year] = @nendo
          @summary_attendance[:month] = @gatudo
          if @summary_attendance.save
            @summary_attendances << @summary_attendance
          end
        end
        return
      end
    end


    # summary_attendanceにuser_idが存在しなければ作成する
    not_summary_attendance=1
    @user.each do |user|

      @summary_attendances.each do |summary_attendance|
        if user.id == summary_attendance.user_id
          not_summary_attendance = 0
        end
      end

      if not_summary_attendance==1
        @summary_attendance = user.summary_attendances.build
        @summary_attendance[:year] = @nendo
        @summary_attendance[:month] = @gatudo
        if @summary_attendance.save
          @summary_attendances << @summary_attendance
        end
      end

      not_summary_attendance=1

    end
    create_years_collection current_user.attendances, freezed
  end



  # def set_attendance
  #   @attendance = Attendance.find(params[:id])
  # end

  # def attendance_params
  #   params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
  #     :kekkin, :hankekkin, :tikoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
  #     :break_time, :kouzyo_time, :work_time, :remarks, :user_id)
  # end

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


  def changed_attendance_years?
    nen_gatudo = params[:paper]
    return ! nen_gatudo.nil?
  end

  # def get_attendance_years(nen_gatudo)

  #   if ! changed_attendance_years?
  #     return Date.today
  #   else
  #     temp = nen_gatudo[:nen_gatudo]
  #     return Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
  #   end
  # end
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
