# -*- coding: utf-8 -*-
class BusinessReportsController < PapersController
  before_action :set_business_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index

    init

    create_business_reports

    session[:years] = "#{@nendo}#{@gatudo}"

    # set_freeze_info

    if !@business_reports.blank?
      @freezed = @business_reports.first.freezed
    else
      @freezed = @business_reports.first.freezed
    end

    @date = @business_reports.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date == nil                                           #更新日時が空なら今日の日付を使用
      @date = Date.today
    end

    # @status = "本人未確認"
    # if @business_reports.first.boss_approved
    #   @status = "上長承認済み"
    # elsif @business_reports.first.self_approved
    #   @status = "本人確認済み"
    # end

    @status = "本人未確認"
    unless @business_reports.first.nil?
      if @business_reports.first.freezed
        @status = "凍結中"
      elsif @business_reports.first.boss_approved
        @status = "上長承認済み"
      elsif @business_reports.first.self_approved
        @status = "本人確認済み"
      end
    end

    #group byにidを追加しないとheroku上でエラーとなったため追加した。でもこれだときちんと動かないよね？
    # year_month_set = current_user.attendances.group('id, year, month')
    # @nengatudo_set = []
    # year_month_set.each do |year_month|
    # @nengatudo_set << [year_month[:year] + "年" + year_month[:month] + "月度", year_month[:year] + "/" + year_month[:month]]
    # end

    # @business_reports = current_user.business_reports.all
  end

  # def set_freeze_info

  #   logger.debug("凍結状態の取得")
    
  #   if view_context.be_self @business_reports.first
  #     @freezed = @business_reports.first.self_approved or @business_reports.first.boss_approved
  #   else
  #     @freezed = @business_reports.first.boss_approved
  #   end

  # end

  def show
  end

  #
  # 新規作成画面
  #
  def new
    init
    @business_report = current_user.business_reports.build
  end

  #
  # 印刷画面
  #
  def print_proc

    years = session[:years]

    if years.nil?
      business_report_years = Date.today
    else
      business_report_years = Date.new(years[0..3].to_i, years[4..5].to_i, 1)
    end

    @nendo = get_nendo(business_report_years)
    @gatudo = get_gatudo(business_report_years)
    @project = get_project
    
    @business_reports = current_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    @date = @business_reports.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date == nil                                           #更新日時が空なら今日の日付を使用
      @date = Date.today
    end

    @title = '業務報告書'
  end

  #
  # 編集画面
  #
  def edit
  end

  #
  # 新規登録処理
  #
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

  #
  # 本人確認処理
  #
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

  #
  # 更新処理
  #
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

  #
  # 削除処理
  #
  def destroy
    @business_report.destroy
    respond_to do |format|
      format.html { redirect_to business_reports_url, notice: '業務報告書を削除しました' }
      format.json { head :no_content }
    end
  end

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

  #
  # 業務報告書の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_business_reports(freezed=false)

    if @business_reports.exists?
      @freezed = @business_reports.first.freezed
      create_years_collection current_user.business_reports, freezed
      return
    end

    if !@business_reports.exists?
      target_date = Date.new(@business_report_years.year, get_month(@business_report_years), 16)
      

      @business_report = current_user.business_reports.build
      @business_report[:year] = @nendo
      @business_report[:month] = @gatudo
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

  # def get_project
  #   if current_user.projects.nil?
  #     Project.new
  #   else
  #     current_user.projects.find_by(active: true)
  #   end
  # end

  def get_business_report_years(business_report, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    else
      temp = current_user.business_reports.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
      if temp.exists?
        years = Date.new(temp.first.year.to_i, temp.first.month.to_i, 1)
      else
        years = Date.today
      end
    end

    if freezed
      years.months_since(1)
    else
      years
    end
  end

end
