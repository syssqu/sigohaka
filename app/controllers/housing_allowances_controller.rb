class HousingAllowancesController < PapersController
  before_action :set_housing_allowance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /housing_allowances
  # GET /housing_allowances.json
  def index
    init


    create_housing_allowances
    # @transportation_expresses = TransportationExpress.all
    # @transportation_express=current_user.transportation_expresses.all
    # @project = current_user.projects.find_by(active: true)
    session[:years] = "#{@nendo}#{@gatudo}"
    @sum=0
    if !@housing_allowances.blank?
      @freezed = @housing_allowances.first.freezed
    else
      @freezed = @housing_allowances.first.freezed
    end 
    # create_years_collection current_user.transportation_expresses, @freezed
    # year = Date.today.year
    # month = Date.today.month
    # day = Date.today.day
    
    # @nendo = Date.today.year
    # @gatudo = Date.today.month

    # if Date.today.day < 16
    #   month = Date.today.months_ago(1).month
    # end

    # if Date.today.day > 15
    #   @gatudo = Date.today.months_since(1).month
    # end

    # if Date.today.month == 12 and Date.today.day > 15
    #   @nendo = Date.today.years_since(1).year
    # end
    
    # @date=Time.parse(session[:date])
    @date=@housing_allowances.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    # =============
    @status = "本人未確認"
    unless @housing_allowances.first.nil?
      if @housing_allowances.first.freezed
        @status = "凍結中"
      elsif @housing_allowances.first.boss_approved
        @status = "上長承認済み"
      elsif @housing_allowances.first.self_approved
        @status = "本人確認済み"
      end
    end

    @housing_allowances=HousingAllowance.all
    @housing_allowances=current_user.housing_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).first
    
  

  end

  # GET /housing_allowances/1
  # GET /housing_allowances/1.json
  def show
  end

  # GET /housing_allowances/new
  def new
    init
    @housing_allowance = current_user.housing_allowances.build
  end

  def print_proc
    years = session[:years]
     @sum = session[:sum]
    if years.nil?
      housing_allowance_years = Date.today
    else
      housing_allowance_years = Date.new(years[0..3].to_i, years[4..-1].to_i, 1)
    end

    @nendo = get_nendo(housing_allowance_years)
    @gatudo = get_gatudo(housing_allowance_years)
    @project = get_project
    
    @housing_allowances = current_user.housing_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @date=@housing_allowances.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end
    @title = '住宅手当申請書'
  end
  # GET /housing_allowances/1/edit
  def edit
  end

  # POST /housing_allowances
  # POST /housing_allowances.json
  def create
    # @housing_allowance = HousingAllowance.new(housing_allowance_params)
    @housing_allowance =current_user.housing_allowances.build(housing_allowance_params)

    respond_to do |format|
      if @housing_allowance.save
        format.html { redirect_to housing_allowances_url, notice: 'Housing allowance was successfully created.' }
        format.json { render :show, status: :created, location: @housing_allowance }
      else
        format.html { render :new }
        format.json { render json: @housing_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @housing_allowances.update_all(["self_approved = ?",true])

    init true
    create_housing_allowances true
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @housing_allowances.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @housing_allowances.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @housing_allowances.update_all(["boss_approved = ?",false])
  end

  # PATCH/PUT /housing_allowances/1
  # PATCH/PUT /housing_allowances/1.json
  def update
    respond_to do |format|
      if @housing_allowance.update(housing_allowance_params)
        format.html { redirect_to housing_allowances_url, notice: 'データの変更を完了しました。' }
        format.json { render :show, status: :ok, location: @housing_allowance }
      else
        format.html { render :edit }
        format.json { render json: @housing_allowance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /housing_allowances/1
  # DELETE /housing_allowances/1.json
  def destroy
    @housing_allowance.destroy
    respond_to do |format|
      format.html { redirect_to housing_allowances_url, notice: 'Housing allowance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_housing_allowance
      @housing_allowance = HousingAllowance.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def housing_allowance_params
      params.require(:housing_allowance).permit(:user_id, :year, :month, :reason, :reason_text, :housing_style, :housing_style_text, :agree_date_s, :agree_date_e, :spouse, :spouse_name, :spouse_other, :support, :support_name1, :support_name2, :money)
    end


    # =================================================================================================-
    #
  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_housing_allowance_years?
      session[:years] = params[:paper][:years]
    end

    @housing_allowance_years = get_years(current_user.housing_allowances, freezed)
    
    @nendo = get_nendo(@housing_allowance_years)
    @gatudo = get_gatudo(@housing_allowance_years)
    @project = get_project

    @housing_allowances = current_user.housing_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
 
  end



  def create_housing_allowances(freezed=false)

    if @housing_allowances.exists?
      @freezed = @housing_allowances.first.freezed
      create_years_collection current_user.housing_allowances, freezed
      return
    end

    if !@housing_allowances.exists?
      target_date = Date.new(@housing_allowance_years.year, get_month(@housing_allowance_years), 16)
      

      @housing_allowance = current_user.housing_allowances.build
      @housing_allowance[:year] = @nendo
      @housing_allowance[:month] = @gatudo
      if @housing_allowance.save
        @housing_allowances << @housing_allowance
        target_date = target_date.tomorrow
      end
      @housing_allowances = current_user.housing_allowances.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    end
    create_years_collection current_user.housing_allowances, freezed
  end

  #
  # 対象年月のセレクトボックス内に含めるデータを作成する
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  #
  def create_housing_allowance_years(freezed=false)
    @nen_gatudo = current_user.housing_allowances.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

    if freezed
      temp = session[:years]
      
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
      next_years = years.months_since(1)
      
      @selected_nen_gatudo = "#{next_years.year}#{next_years.month}"
      session[:years] = @selected_nen_gatudo
    end
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

  # 画面の対象年月が変更されたどうかを判定する
  # @return [Boolean] 対象年月が変更されている場合はtrueを返す。そうでない場合はfalseを返す
  def changed_housing_allowance_years?
    return ! params[:paper].nil?
  end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   対象年月の翌月を返す
  # それ以外の場合
  #   対象年月を返す
  # @param [Date] housing_allowance
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @return [Date] 対象勤怠日付
  def get_housing_allowance_years(transportation_express, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    else
      temp = current_user.housing_allowances.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
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
