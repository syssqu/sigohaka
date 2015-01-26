# -*- coding: utf-8 -*-
class KintaiHeaderController < ApplicationController
  #
  # 更新処理
  #
  def edit
    logger.info("edit_header")
    logger.debug("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: session[:years][0..3], month: session[:years][4..5])
  end

  #
  # 更新処理
  #
  def update
    logger.info("update_header")

    @kintai_header = KintaiHeader.find(params[:kintai_header][:id])
    
    if @kintai_header.update_attributes(header_params)

      path = attendances_path
      
      redirect_to path, notice: '更新しました。'
    else
      render :edit_header
    end
  end

  private
  def header_params
    params.require(:kintai_header).permit(:user_name, :section_name, :project_name)
  end
end
