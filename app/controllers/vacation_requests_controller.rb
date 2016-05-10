class VacationRequestsController < PapersController
  before_action :set_vacation_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /vacation_requests
  # GET /vacation_requests.json
  def index
    init

    unless @vacation_requests.exists?
      create_vacation_requests
    end

    unless view_context.target_user.kintai_headers.exists?(year: @nendo.to_s,month: @gatudo.to_s)
      create_kintai_header
    end

    @years = create_years_collection view_context.target_user.vacation_requests # 対象年月リスト 要修正
    @users = create_users_collection                                      # 対象ユーザーリスト

    session[:years] = "#{@nendo}#{@gatudo}"
    @sum=0

    if !@vacation_requests.blank?
      @freezed = @vacation_requests.first.freezed
    end

    # @date=Time.parse(session[:date])
    @date=@vacation_requests.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    # =============
    @status = "本人未確認"
    unless @vacation_requests.first.nil?
      if @vacation_requests.first.freezed
        @status = "凍結中"
      elsif @vacation_requests.first.boss_approved
        @status = "上長承認済み"
      elsif @vacation_requests.first.self_approved
        @status = "本人確認済み"
      end
    end
    # =============
  end

  # GET /vacation_requests/1
  # GET /vacation_requests/1.json
  def show
    @vacation_requests = current_user.vacation_requests.find(params[:id])
  end

  # GET /vacation_requests/new
  def new
    init
    @vacation_request = current_user.vacation_requests.build
  end

  # GET /vacation_requests/1/edit
  def edit
  end

  # POST /vacation_requests
  # POST /vacation_requests.json
  def create
    @vacation_request = current_user.vacation_requests.build(vacation_request_params)

    if @vacation_request.save
      redirect_to @vacation_request, notice: '休暇届を作成しました'
    else
      render :new
    end
  end

  # PATCH/PUT /vacation_requests/1
  # PATCH/PUT /vacation_requests/1.json
  def update
    respond_to do |format|
      if @vacation_request.update(vacation_request_params)
        format.html { redirect_to @vacation_request, notice: '休暇届を更新しました' }
        format.json { render :show, status: :ok, location: @vacation_request }
      else
        format.html { render :edit }
        format.json { render json: @vacation_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacation_requests/1
  # DELETE /vacation_requests/1.json
  def destroy
    @vacation_request.destroy
    respond_to do |format|
      format.html { redirect_to vacation_requests_url, notice: '休暇届を削除しました' }
      format.json { head :no_content }
    end
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @vacation_requests.update_all(["self_approved = ?",true])

    init true
    create_vacation_requests true
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @vacation_requests.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @vacation_requests.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @vacation_requests.update_all(["boss_approved = ?",false])
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
    @vacation_requests = VacationRequest.all
    @vacation_requests = current_user.vacation_requests.all
    @project = current_user.projects.find_by(active: true)
    @date=@vacation_requests.maximum(:updated_at ,:include)

    @vacation_request = current_user.vacation_requests.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    respond_to do |format|

      format.html { redirect_to print_vacation_requests_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: '休暇届',
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  private

    # =================================================================================================-
    #
    # 勤怠日付の初期化
    #
    def init(freezed=false)

      if changed_vacation_request_years?
        session[:years] = params[:paper][:years]
      end

      @vacation_request_years = get_years(current_user.vacation_requests, freezed)

      @nendo = get_nendo(@vacation_request_years)
      @gatudo = get_gatudo(@vacation_request_years)
      @project = get_project

      @vacation_requests = current_user.vacation_requests.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

      @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
    end

    def create_vacation_requests(freezed=false)

      if @vacation_requests.exists?
        @freezed = @vacation_requests.first.freezed
        create_years_collection current_user.vacation_requests, freezed
        return
      end

      if !@vacation_requests.exists?
        target_date = Date.new(@vacation_request_years.year, get_month(@vacation_request_years), 16)


        @vacation_request = current_user.vacation_requests.build
        @vacation_request[:year] = @nendo
        @vacation_request[:month] = @gatudo

        return [{ id: "#{@nendo}#{@gatudo}", value: "#{@nendo}年#{@gatudo}月度"}]
      end
    end

    # 画面の対象年月が変更されたどうかを判定する
    # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
    def changed_vacation_request_years?
      return ! params[:paper].nil?
    end

    # 対象日付の月度を返す
    # @param [Date] target_date 対象日付
    # @return [Integer] 対象日付の月度
    def get_gatudo(target_date)
      gatudo = target_date.month

      if target_date.day > 15
        gatudo = target_date.months_since(1).month
      end

      gatudo
    end

    # 対象日付の年度を返す
    # @param [Date] target_date 対象日付
    # @return [Integer] 対象日付の年度
    def get_nendo(target_date)
      nendo = target_date.year

      if target_date.month == 12 and target_date.day > 15
        nendo = target_date.years_since(1).year
      end

      nendo
    end

    # 対象日付の月を返す
    # 対象日付の日が15日以前の場合に先月の月を返す。そうでない場合は当月の月を返す
    # @param [Date] target_date 対象日付
    # @return [Integer] 対象日付の月
    def get_month(target_date)
      month = target_date.month

      if target_date.day < 16
        month = target_date.months_ago(1).month
      end

      month
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_vacation_request
      @vacation_request = VacationRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacation_request_params
      params.require(:vacation_request).permit(:user_id, :start_date, :end_date, :term, :category, :reason, :note, :year, :month)
    end

end
