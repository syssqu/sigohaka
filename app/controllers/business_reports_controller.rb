# -*- coding: utf-8 -*-
class BusinessReportsController < PapersController
  before_action :set_business_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  #
  # 一覧画面
  #
  def index
    logger.info("business_reports_controller::index")

    init

    unless @business_reports.exists?
      create_business_reports
    end

    unless view_context.target_user.kintai_headers.exists?(year: @nendo.to_s,month: @gatudo.to_s)
      create_kintai_header
    end
    

    @years = create_years_collection view_context.target_user.business_reports # 対象年月リスト 要修正
    @users = create_users_collection                                      # 対象ユーザーリスト
    
    set_freeze_info @business_reports

    set_status @business_reports

    @be_self = view_context.be_self @business_reports.first
  end

  #
  # 印刷画面
  #
  def print_proc

    setBasicInfo
    
    @business_reports = view_context.target_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @date = @business_reports.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
    # if @date == nil                                           #更新日時が空なら今日の日付を使用
    #   @date = Date.today
    # end

    @title = '業務報告書'
  end

  def show
  end

  #
  # 新規作成画面
  #
  def new
    init
    @business_report = view_context.target_user.business_reports.build
  end

  #
  # 新規登録処理
  #
  def create
    @business_report = view_context.target_user.business_reports.build(business_report_params)

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
  # 編集画面
  #
  def edit
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

  def update_header
    super(attendances_path)
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @business_reports.update_all(["self_approved = ?",true])

    # タイムラインへメッセージを投稿
    posting_check_proc("業務報告書")
    
    init true
    create_business_reports
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @business_reports.update_all(["self_approved = ?",false])

    # タイムラインへメッセージを投稿
    posting_check_proc("業務報告書")
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @business_reports.update_all(["boss_approved = ?",true])

    temp_user = @business_reports.first.user

    # タイムラインへメッセージを投稿
    posting_approve_proc("業務報告書", temp_user)
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @business_reports.update_all(["boss_approved = ?",false])

    temp_user = @business_reports.first.user
    
    # タイムラインへメッセージを投稿
    posting_cancel_approve_proc("業務報告書", temp_user)
  end

  private

  def set_business_report
    @business_report = BusinessReport.find(params[:id])
  end

  def business_report_params
    params.require(:business_report).permit(:user_id, :naiyou, :jisseki, :tool, :self_purpose, :self_value, :self_reason, :user_situation, :request, :reflection, :develop_purpose, :develop_jisseki, :note)
  end

  def init(freezed=false)

    logger.info("business_reports_controller::init")

    super(view_context.target_user.business_reports, freezed)
    
    @business_reports = view_context.target_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)

  end

  #
  # 業務報告書の作成
  # ※事前にinitメソッドを実行して、対象年月を確定しておく必要あり
  #
  def create_business_reports(freezed=false)

    logger.info("create_business_reports")
    
    target_date = Date.new( YearsController.get_nendo(@target_years), YearsController.get_month(@target_years), 16)

    @business_report = view_context.target_user.business_reports.build
    @business_report[:year] = @nendo
    @business_report[:month] = @gatudo
    
    if @business_report.save
      @business_reports << @business_report
      target_date = target_date.tomorrow
    end

    @business_reports = view_context.target_user.business_reports.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
  end
end
