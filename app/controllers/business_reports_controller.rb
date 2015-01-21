# -*- coding: utf-8 -*-
class BusinessReportsController < PapersController
  before_action :set_business_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index

    init

    create_business_reports

    session[:years] = "#{@nendo}#{@gatudo}"

    set_freeze_info

    @date=@business_reports.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                           #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    @status = "本人未確認"
    if @business_reports.first.boss_approved
      @status = "上長承認済み"
    elsif @business_reports.first.self_approved
      @status = "本人確認済み"
    end

    #group byにidを追加しないとheroku上でエラーとなったため追加した。でもこれだときちんと動かないよね？
    # year_month_set = current_user.attendances.group('id, year, month')
    # @nengatudo_set = []
    # year_month_set.each do |year_month|
    # @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    # end

    # @business_reports = current_user.business_reports.all
  end

  def set_freeze_info

    logger.debug("凍結状態の取得")
    
    if view_context.be_self @business_reports.first
      @freezed = @business_reports.first.self_approved or @business_reports.first.boss_approved
    else
      @freezed = @business_reports.first.boss_approved
    end

  end

  def show
  end

  def new
    init
    @business_report = current_user.business_reports.build
  end

  def print_proc

    years = session[:years]

    if years.nil?
      business_reports_years = Date.today
    else
      business_reports_years = Date.new(years[0..3].to_i, years[4..5].to_i, 1)
    end

    @nendo = get_target_year(business_reports_years)
    @gatudo = get_gatudo(business_reports_years)
    @project = get_project
    
    @business_reports = current_user.attendances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    @title = '業務報告書'
  end

  def edit
  end

  def create
    @business_report = current_user.business_reports.build(business_report_params)

    respond_to do |format|
      if @business_report.save
        format.html { redirect_to business_reports_url, notice: '業務報告書を作成しました' }
        format.json { render :show, status: :created, location: @business_report }
      else
        format.html { render :new }
        format.json { render json: @business_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_proc
    init
    @business_reports.update_all(["self_approved = ?",true])

    init true
    create_business_reports true
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @business_reports.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @business_reports.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @business_reports.update_all(["boss_approved = ?",false])
  end

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

  def destroy
    @business_report.destroy
    respond_to do |format|
      format.html { redirect_to business_reports_url, notice: '業務報告書を削除しました' }
      format.json { head :no_content }
    end
  end

  # def print

  #   year = Date.today.year
  #   month = Date.today.month
  #   day = Date.today.day
    
  #   @nendo = Date.today.year
  #   @gatudo = Date.today.month

  #   if Date.today.day < 16
  #     month = Date.today.months_ago(1).month
  #   end

  #   if Date.today.day > 15
  #     @gatudo = Date.today.months_since(1).month
  #   end

  #   if Date.today.month == 12 and Date.today.day > 15
  #     @nendo = Date.today.years_since(1).year
  #   end
  #   @business_reports = BusinessReport.all
  #   @business_reports = current_user.business_reports.all
  #   @project = current_user.projects.find_by(active: true)
  #   @date=@business_reports.maximum(:updated_at ,:include)

  #   @business_report = current_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    
  #   respond_to do |format|

  #     format.html { redirect_to print_business_reports_path(format: :pdf, debug: 1)}
  #     format.pdf do
  #       render pdf: '業務報告書',
  #              encoding: 'UTF-8',
  #              layout: 'pdf.html',
  #              show_as_html: params[:debug].present?
  #     end
  #   end
  # end


  private

  def set_business_report
    @business_report = BusinessReport.find(params[:id])
  end

  def business_report_params
    params.require(:business_report).permit(:user_id, :naiyou, :jisseki, :tool, :self_purpose, :self_value, :self_reason, :user_situation, :request, :reflection, :develop_purpose, :develop_jisseki, :note)
  end

  def init(freezed=false)

    if changed_business_report_years?
      session[:years] = params[:paper][:years]
    end

    @business_report_years = get_years(current_user.business_reports, freezed)
    
    @nendo = get_nendo(@business_report_years)
    @gatudo = get_gatudo(@business_report_years)
    @project = get_project

    @business_reports = current_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
 
  end

  def create_business_reports(freezed=false)

    if @business_reports.exists?
      @freezed = @business_reports.first.freezed
      create_years_collection current_user.business_reports, freezed
      return
    end

    if !@business_reports.exists?
      target_date = Date.new(@business_report_years.year, get_month(@business_reports_years), 16)
      

      @business_reports = current_user.business_reports.build
      @business_reports[:year] = @nendo
      @business_reports[:month] = @gatudo
      if @business_report.save
        @business_reports << @business_report
        target_date = target_date.tomorrow
      end
      @business_reports = current_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    end
    create_years_collection current_user.business_reports, freezed
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

  def changed_business_report_years?
    return ! params[:paper].nil?
  end

    def get_project
      if current_user.projects.nil?
        Project.new
      else
        current_user.projects.find_by(active: true)
      end
    end

end
