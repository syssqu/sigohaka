# -*- coding: utf-8 -*-
class ResumesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def print
    respond_to do |format|
      # format.html { redirect_to print_attendances_path(format: :pdf)}
      # format.pdf do
      #   render pdf: '勤務状況報告書',
      #          encoding: 'UTF-8',
      #          layout: 'pdf.html'
      format.html { redirect_to resumes_print_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '技術経歴書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end
end
