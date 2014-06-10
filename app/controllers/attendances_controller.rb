# -*- coding: utf-8 -*-
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index

    processing_date = Date.today

    @nendo = get_nendo(processing_date)
    @gatudo = get_gatudo(processing_date)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    year_month_set = current_user.attendances.group('year, month')
    @nengatudo_set = []
    year_month_set.each do |year_month|
      # nengatudo = { key: year_month[:year] + "/" + year_month[:month], value: year_month[:year] + "年" + year_month[:month] + "月度"}
      # @nengatudo_set << nengatudo
      @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    end

    if current_user.kinmu_patterns.first.nil?
      flash.now[:alert] = '勤務パターンを登録して下さい。'
      return
    end

    if ! @attendances.exists?
        
      target_date = Date.new(processing_date.year, get_month(processing_date), 16)
      next_date = target_date.months_since(1)
      
      while target_date != next_date

        @attendance = current_user.attendances.build
        
        @attendance[:attendance_date] = target_date
        @attendance[:year] = @nendo
        @attendance[:month] = @gatudo

        @attendance[:wday] = target_date.wday

        if holiday?(target_date)
          @attendance[:holiday] = "1"
        elsif ! current_user.kinmu_patterns.first.nil?
          @attendance[:pattern] = current_user.kinmu_patterns.first.code
          @attendance[:start_time] = current_user.kinmu_patterns.first.start_time
          @attendance[:end_time] = current_user.kinmu_patterns.first.end_time
          @attendance[:work_time] = current_user.kinmu_patterns.first.work_time
          @attendance[:holiday] = "0"

        end

        if @attendance.save
          @attendances << @attendance
          target_date = target_date.tomorrow
        else
          break
        end
      end
    end

    # 課会や全体会の情報等々、通常勤怠から外れる分はattendance_othersとして管理する
    @others = current_user.attendance_others
    
    if ! @others.exists?
      @other = current_user.attendance_others.build(summary:"課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
      if @other.save
        @others << @other
      end

      @other = current_user.attendance_others.build(summary:"全体会")
      if @other.save
        @others << @other
      end

      @other = current_user.attendance_others.build()
      if @other.save
        @others << @other
      end
    end
    
  end

  def init_attendances
    redirect_to attendances_path, notice: 'データを初期化しました。'
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to attendances_path, notice: '登録しました。'
    else
      render :new
    end
  end

  def edit
  end

  def confirm
    @attendance = Attendance.new(params[:attendance])

    if ! attendance.valid?
      render :edit
    end
  end

  def update
    if @attendance.update_attributes(attendance_params)
      redirect_to attendances_path, notice: '更新しました。'
    else
      render :edit
    end
  end

  def print

    processing_date = Date.today

    @nendo = get_nendo(processing_date)
    @gatudo = get_gatudo(processing_date)
    @project = get_project
    
    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @others = current_user.attendance_others
    
    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to print_attendances_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '勤務状況報告書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
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

    def get_project
      if current_user.projects.nil?
        Project.new
      else
        current_user.projects.find_by(active: true)
      end
    end

    def holiday?(target_date)
      target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
    end
end
