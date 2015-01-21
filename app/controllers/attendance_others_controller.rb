# -*- coding: utf-8 -*-
class AttendanceOthersController < ApplicationController
  before_action :set_attendance_other, only: [:show, :edit, :update, :destroy]

  # GET /attendance_others
  # GET /attendance_others.json
  def index
    @attendance_others = current_user.attendan_others
  end

  # GET /attendance_others/1
  # GET /attendance_others/1.json
  def show
  end

  # GET /attendance_others/new
  def new
    @attendance_other = AttendanceOther.new
  end

  # GET /attendance_others/1/edit
  def edit
  end

  # POST /attendance_others
  # POST /attendance_others.json
  def create
    @attendance_other = AttendanceOther.new(attendance_other_params)

    if @attendance_other.save
      redirect_to @attendance_other, notice: '作成しました。'
    else
      render :new
    end
  end

  # PATCH/PUT /attendance_others/1
  # PATCH/PUT /attendance_others/1.json
  def update
    if @attendance_other.update(attendance_other_params)
      redirect_to attendances_path, notice: '更新しました。'
    else
      render :edit
    end
  end

  # DELETE /attendance_others/1
  # DELETE /attendance_others/1.json
  def destroy
    @attendance_other.destroy
    redirect_to attendance_others_url, notice: '削除しました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance_other
      @attendance_other = AttendanceOther.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_other_params
      params.require(:attendance_other).permit(:summary, :start_time, :end_time, :over_time, :holiday_time, :midnight_time,:break_time, :kouzyo_time, :work_time, :remarks, :user_id, :year, :month)
    end
end
