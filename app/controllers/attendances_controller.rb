# -*- coding: utf-8 -*-
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index

    @youbi = %w[日 月 火 水 木 金 土]

    year = Date.today.year
    month = Date.today.month
    day = Date.today.day

    if Date.today.day < 16
      month = Date.today.months_ago(1).month
    end

    @attendances = Attendance.find_by(user_id: current_user.id, year: year, month: month)

    if @attendances.nil?
        @attendances = []
        
        target_date = Date.new(year, month, 16)
        next_date = target_date.months_since(1)
    
        while target_date != next_date

          @attendance = Attendance.new
          
          @attendance[:attendance_date] = target_date
          @attendance[:start_time] = "09:00"
          @attendance[:end_time] = "18:00"
          @attendance[:work_time] = "8.0"

          @attendance[:wday] = target_date.wday
          
          if @attendance.save
            @attendances << @attendance
            target_date = target_date.tomorrow
          else
            break
          end
        end
    end
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

  def update
    if @attendance.update(attendance_params)
      redirect_to attendances_path, notice: '更新しました。'
    else
      render :edit
    end
  end

  private
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:attendance_date, :year, :month, :day, :wday, :pattern, :start_time, :end_time, :byouketu,
      :kekkin, :hankekkin, :titoku, :soutai, :gaisyutu, :tokkyuu, :furikyuu, :yuukyuu, :syuttyou, :over_time, :holiday_time, :midnight_time,
      :break_time, :kouzyo_time, :work_time, :remarks, :user_id)
  end
end
