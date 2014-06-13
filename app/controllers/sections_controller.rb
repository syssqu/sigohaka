# -*- coding: utf-8 -*-
class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # before_filter :authenticate_admin_user!

  def index
    @sections = Section.all
  end

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to @section, notice: '課を作成しました'
    else
      render :new
    end
  end

  def update
    if @section.update(section_params)
      redirect_to @section, notice: '課を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:code, :name)
    end
end
