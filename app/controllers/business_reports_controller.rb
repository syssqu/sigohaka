# -*- coding: utf-8 -*-
class BusinessReportsController < ApplicationController
  before_action :set_business_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /business_reports
  # GET /business_reports.json
  def index

    processing_date = Date.today

    @nendo = get_nendo(processing_date)
    @gatudo = get_gatudo(processing_date)
    @project = get_project

    @attendances = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    year_month_set = current_user.attendances.group('id, year, month')
    @nengatudo_set = []
    year_month_set.each do |year_month|
      # nengatudo = { key: year_month[:year] + "/" + year_month[:month], value: year_month[:year] + "年" + year_month[:month] + "月度"}
      # @nengatudo_set << nengatudo
      @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    end

    @business_reports = current_user.business_reports.all
  end

  # GET /business_reports/1
  # GET /business_reports/1.json
  def show
    @business_reports = current_user.business_reports.find(params[:id])
  end

  # GET /business_reports/new
  def new
    @business_report = current_user.business_reports.build
  end

  # GET /business_reports/1/edit
  def edit
  end

  # POST /business_reports
  # POST /business_reports.json
  def create
    @business_report = current_user.business_reports.build(business_report_params)

    respond_to do |format|
      if @business_report.save
        format.html { redirect_to @business_report, notice: '業務報告書を作成しました' }
        format.json { render :show, status: :created, location: @business_report }
      else
        format.html { render :new }
        format.json { render json: @business_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_reports/1
  # PATCH/PUT /business_reports/1.json
  def update
    respond_to do |format|
      if @business_report.update(business_report_params)
        format.html { redirect_to business_reports_url, notice: '業務報告書を更新しました' }
        format.json { render :show, status: :ok, location: @business_report }
      else
        format.html { render :edit }
        format.json { render json: @business_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_reports/1
  # DELETE /business_reports/1.json
  def destroy
    @business_report.destroy
    respond_to do |format|
      format.html { redirect_to business_reports_url, notice: '業務報告書を削除しました' }
      format.json { head :no_content }
    end
  end

  def print

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
    @business_reports = BusinessReport.all
    @business_reports = current_user.business_reports.all
    @project = current_user.projects.find_by(active: true)
    @date=@business_reports.maximum(:updated_at ,:include)

    @business_report = current_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    
    respond_to do |format|

      format.html { redirect_to print_business_reports_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '業務報告書',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_report
      @business_report = BusinessReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_report_params
      params.require(:business_report).permit(:user_id, :naiyou, :jisseki, :tool, :self_purpose, :self_value, :self_reason, :user_situation, :request, :reflection, :develop_purpose, :develop_jisseki, :note)
    end

    def get_gatudo(target_date)
      gatudo = target_date.month

      if target_date.day > 15
        gatudo = target_date.months_since(1).month
      end

      gatudo
    end

    def get_nendo(target_date)
      nendo = target_date.year

      if target_date.month == 12 and target_date.day > 15
        nendo = target_date.years_since(1).year
      end

      nendo
    end

    def get_month(target_date)
      month = target_date.month

      if target_date.day < 16
        month = target_date.months_ago(1).month
      end

      month
    end

    def get_project
      if current_user.projects.nil?
        Project.new
      else
        current_user.projects.find_by(active: true)
      end
    end

    def holiday?(target_date)
      target_date.wday == 0 or target_date.wday == 6 or target_date.national_holiday?
    end
end
