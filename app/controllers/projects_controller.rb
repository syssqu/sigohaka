# -*- coding: utf-8 -*-
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @projects = current_user.projects.order(:start_date)
  end

  def show

  end

  def new
    @project = current_user.projects.build
  end

  def edit
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to  projects_path, notice: 'プロジェクトを作成しました。'
    else
      render :new
    end
  end

  def update

    ActiveRecord::Base.transaction do

      if params[:project][:active] == "1"
        current_user.projects.update_all(["active = ?", false])
      end

      @project.update!(project_params)
    end

    redirect_to projects_path , notice: 'プロジェクトを更新しました。'

  rescue => e
    # raise e
    render :edit, notice: 'プロジェクトを更新に失敗しました。'
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'プロジェクトを削除しました。'
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:code, :name, :start_date, :end_date, :summary, :description,
                                      :os, :language, :database, :dep_size, :role, :experience, :remarks, :active)
    end
end
