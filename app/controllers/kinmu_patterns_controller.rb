# -*- coding: utf-8 -*-
class KinmuPatternsController < ApplicationController
  before_action :set_kinmu_pattern, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @kinmu_patterns = current_user.kinmu_patterns.where("code <> '*'")

    if ! @kinmu_patterns.exists?
      (1..5).each do |num|
        @kinmu_pattern = current_user.kinmu_patterns.build

        # デフォルトの勤務パターン
        @kinmu_pattern[:code] = num.to_s
        if num == 1
          @kinmu_pattern[:start_time] = "9:00"
          @kinmu_pattern[:end_time] = "18:00"
          @kinmu_pattern[:break_time] = 1.00
          @kinmu_pattern[:work_time] = 8.00
        end

        if ! @kinmu_pattern.save
          logger.debug("勤務パターン登録エラー")
          break
        end
      end

      @kinmu_patterns = current_user.kinmu_patterns
    end
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
      redirect_to kinmu_patterns_path, notic: '勤務パターンを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @kinmu_pattern.destroy
    redirect_to kinmu_patterns_url, notice: '勤務パターンを削除しました'
  end

  private
    def set_kinmu_pattern
      @kinmu_pattern = KinmuPattern.find(params[:id])
    end

    def kinmu_pattern_params
      params.require(:kinmu_pattern).permit(:code, :start_time, :end_time, :break_time, :midnight_break_time, :work_time, :shift, :user_id)
    end
end
