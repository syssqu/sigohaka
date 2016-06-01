# -*- coding: utf-8 -*-
class KatagakisController < ApplicationController
  before_action :set_katagaki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # before_filter :authenticate_admin_user!

  def index
    @katagakis = Katagaki.all.order(:id)
  end

  def show
  end

  def new
    @katagaki = Katagaki.new
  end

  def edit
  end

  def create
    @katagaki = Katagaki.new(katagaki_params)

    if @katagaki.save
      redirect_to katagakis_path, notice: '役職作成しました'
    else
      render :new
    end
  end

  def update
    if @katagaki.update(katagaki_params)
      redirect_to katagakis_path, notice: '役職を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @katagaki.destroy
    respond_to do |format|
      format.html { redirect_to katagakis_url, notice: '役職を削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_katagaki
      @katagaki = Katagaki.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def katagaki_params
      params.require(:katagaki).permit(:name, :role)
    end
end
