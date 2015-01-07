class CommutesController < PapersController
  before_action :set_commute, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /commutes
  # GET /commutes.json
  def index

    init


    create_commutes
    create_reasons
    session[:years] = "#{@nendo}#{@gatudo}"
    @sum=0
    if !@commutes.blank?
      @freezed = @commutes.first.freezed
    else
      @freezed = @commutes.first.freezed
    end 
     @date=@commutes.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    # =============
    @status = "本人未確認"
    unless @commutes.first.nil?
      if @commutes.first.freezed
        @status = "凍結中"
      elsif @commutes.first.boss_approved
        @status = "上長承認済み"
      elsif @commutes.first.self_approved
        @status = "本人確認済み"
      end
    end
    # =============


    # @commutes = Commute.all
    # @commute=current_user.commutes.all
    @reasons=Reason.all
    @reasons=current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).first
    # @sum=0

    # @project = current_user.projects.find_by(active: true)

    # @date=@commute.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    # if @date==nil                                                 #更新日時が空なら今日の日付を使用
    #   @date=Date.today
    # end

  end

  # GET /commutes/1
  # GET /commutes/1.json
  def show
  end

  # GET /commutes/new
  def new
    init
    @commute = current_user.commutes.build
    # @commute = Commute.new
  end

  def print_proc
    years = session[:years]
     @sum = session[:sum]
    if years.nil?
      commute_years = Date.today
    else
      commute_years = Date.new(years[0..3].to_i, years[4..-1].to_i, 1)
    end

    @nendo = get_nendo(commute_years)
    @gatudo = get_gatudo(commute_years)
    @project = get_project
    
    @commutes = current_user.commutes.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    @reasons = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s).first
    @date=@commutes.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end
    @title = '現住所変更及び通勤届'
  end

  # GET /commutes/1/edit
  def edit
  end

  # POST /commutes
  # POST /commutes.json
  def create
    # @commute = Commute.new(commute_params)
    @commute = current_user.commutes.build(commute_params)

    respond_to do |format|
      if @commute.save
        format.html { redirect_to commutes_url, notice: 'データの登録を完了しました。' }
        format.json { render :show, status: :created, location: @commute }
      else
        format.html { render :new }
        format.json { render json: @commute.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @commutes.update_all(["self_approved = ?",true])
    @reasons.update_all(["self_approved = ?",true])

    init true
    create_commutes true
    # create_reasons      二つあると二月分、月度が増える
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @commutes.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @commutes.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @commutes.update_all(["boss_approved = ?",false])
  end

  # PATCH/PUT /commutes/1
  # PATCH/PUT /commutes/1.json
  def update
    respond_to do |format|
      if @commute.update(commute_params)
        format.html { redirect_to commutes_url, notice: '編集を完了しました。' }
        format.json { render :show, status: :ok, location: @commute }
      else
        format.html { render :edit }
        format.json { render json: @commute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commutes/1
  # DELETE /commutes/1.json
  def destroy
    @commute.destroy
    respond_to do |format|
      format.html { redirect_to commutes_url, notice: 'データを削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commute
      @commute = Commute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commute_params
      params.require(:commute).permit(:user_id, :year, :month, :reason, :reason_text, :transport, :segment1, :segment2, :money)
    end
    # =================================================================================================-
    #
  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_commute_years?
      session[:years] = params[:paper][:years]
    end

    @commute_years = get_years(current_user.commutes, freezed)
    
    @nendo = get_nendo(@commute_years)
    @gatudo = get_gatudo(@commute_years)
    @project = get_project

    @commutes = current_user.commutes.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)


     if changed_commute_years?
      session[:years] = params[:paper][:years]
    end

    @reason_years = get_years(current_user.reasons, freezed)
    
    @nendo = get_nendo(@reason_years)
    @gatudo = get_gatudo(@reason_years)
    @project = get_project

    @reasons = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
 
    
  end



  def create_commutes(freezed=false)

    if @commutes.exists?
      @freezed = @commutes.first.freezed
      create_years_collection current_user.commutes, freezed
      return
    end

    if !@commutes.exists?
      target_date = Date.new(@commute_years.year, get_month(@commute_years), 16)
      

      @commute = current_user.commutes.build
      @commute[:year] = @nendo
      @commute[:month] = @gatudo
      if @commute.save
        @commutes << @commute
        target_date = target_date.tomorrow
      end
      @commutes = current_user.commutes.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
      # @reasons = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    end
    create_years_collection current_user.commutes, freezed


    
  end

   def create_reasons(freezed=false)

    if @reasons.exists?
      @freezed = @reasons.first.freezed
      create_years_collection current_user.reasons, freezed
      return
    end

    if !@reasons.exists?
      target_date = Date.new(@commute_years.year, get_month(@commute_years), 16)
      

      @reason = current_user.reasons.build
      @reason[:year] = @nendo
      @reason[:month] = @gatudo
      if @reason.save
        @reasons << @reason
        target_date = target_date.tomorrow
      end
      # @commutes = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
      @reasons = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
    end
    create_years_collection current_user.reasons, freezed
   end

  #   def init(freezed=false)

  #   unless session[:years].blank?
  #     @selected_nen_gatudo = session[:years]
  #   end
    
  #   if changed_transportation_express_years?
  #     @selected_nen_gatudo = params[:transportation_express][:nen_gatudo]
  #     session[:years] = params[:transportation_express][:nen_gatudo]
  #   end

  #   @transportation_express_years = get_transportation_express_years(params[:transportation_express], freezed)
    
  #   @nendo = get_nendo(@transportation_express_years)
  #   @gatudo = get_gatudo(@transportation_express_years)
  #   @project = get_project

  #   @transportation_express = current_user.transportation_expresses.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
  # end

  
  #
  # 対象年月のセレクトボックス内に含めるデータを作成する
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  #
  def create_commute_years(freezed=false)
    @nen_gatudo = current_user.commutes.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

    if freezed
      temp = session[:years]
      
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
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
  def changed_commute_years?
    return ! params[:paper].nil?
  end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   対象年月の翌月を返す
  # それ以外の場合
  #   対象年月を返す
  # @param [Date] tranportation_express
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @return [Date] 対象勤怠日付
  def get_commute_years(transportation_express, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
    else
      temp = current_user.commutes.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
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
