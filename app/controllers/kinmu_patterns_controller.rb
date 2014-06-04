# -*- coding: utf-8 -*-
class KinmuPatternsController < ApplicationController
  before_action :set_kinmu_pattern, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @kinmu_patterns = KinmuPattern.all
  end

  def show
  end

  def new
    @kinmu_pattern = current_user.kinmu_patterns.build
  end

  def edit
  end

  def create
    @kinmu_pattern = current_user.kinmu_patterns.build(kinmu_pattern_params)

    if @kinmu_pattern.save
      redirect_to @kinmu_pattern, notice: '勤務パターンを作成しました'
    else
      render :new
    end
  end

  def update
    if @kinmu_pattern.update(kinmu_pattern_params)
      redirect_to @kinmu_pattern, notic: '勤務パターンを更新しました' 
    else
      render :edit
    end
  end

  def destroy
    @kinmu_pattern.destroy
    redirect_to kinmu_patterns_url, notice: 'Kinmu pattern was successfully destroyed.'
  end

  private
    def set_kinmu_pattern
      @kinmu_pattern = KinmuPattern.find(params[:id])
    end

    def kinmu_pattern_params
      params.require(:kinmu_pattern).permit(:start_time, :end_time, :break_time, :work_time, :user_id)
    end
end
