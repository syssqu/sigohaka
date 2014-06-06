# -*- coding: utf-8 -*-
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index

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

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo, @gatudo)

    if ! @attendances.exists?
        
        target_date = Date.new(year, month, 16)
        next_date = target_date.months_since(1)
    
        while target_date != next_date

          @attendance = current_user.attendances.build
          
          @attendance[:attendance_date] = target_date
          @attendance[:year] = @nendo
          @attendance[:month] = @gatudo
          

          @attendance[:wday] = target_date.wday

          if holiday?(target_date)
            @attendance[:holiday] = "1"
          else
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
  end

  def holiday?(target_date)
    target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
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
    respond_to do |format|
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
end
