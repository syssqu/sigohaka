# -*- coding: utf-8 -*-
class TransportationExpressesController < PapersController
  before_action :set_transportation_express, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /transportation_expresses
  # GET /transportation_expresses.json
  def index

    init


    create_transportation_expresses
    # @transportation_expresses = TransportationExpress.all
    # @transportation_express=current_user.transportation_expresses.all
    # @project = current_user.projects.find_by(active: true)
    session[:years] = "#{@nendo}#{@gatudo}"
    @sum=0
    @freezed = @transportation_expresses.first.freezed
    create_years_collection current_user.transportation_expresses, @freezed
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
    @date=@transportation_expresses.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end

    # =============
    @status = "本人未確認"
    if @transportation_expresses.first.freezed
      @status = "凍結中"
    elsif @transportation_expresses.first.boss_approved
      @status = "上長承認済み"
    elsif @transportation_expresses.first.self_approved
      @status = "本人確認済み"
    end
    # =============
  end

  # GET /transportation_expresses/1
  # GET /transportation_expresses/1.json
  def show
  end

  # GET /transportation_expresses/new
  def new
    init
    @transportation_express = current_user.transportation_expresses.build
  end

  def transportation_confirm 
    @transportation_express = current_user.transportation_expresses.build(transportation_express_params)
  end

  def print_proc
     years = session[:years]

    if years.nil?
      transportation_express_years = Date.today
    else
      transportation_express_years = Date.new(years[0..3].to_i, years[4..5].to_i, 1)
    end

    @nendo = get_nendo(transportation_express_years)
    @gatudo = get_gatudo(transportation_express_years)
    @project = get_project
    
    @transportation_expresses = current_user.transportation_expresses.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    @date=@transportation_expresses.maximum(:updated_at ,:include)  #更新日時が一番新しいものを取得
    if @date==nil                                                 #更新日時が空なら今日の日付を使用
      @date=Date.today
    end
    @title = '交通費精算書'
  end

  # GET /transportation_expresses/1/edit
  def edit
  end

  # POST /transportation_expresses
  # POST /transportation_expresses.json
  def create
    @transportation_express = current_user.transportation_expresses.build(transportation_express_params)

    respond_to do |format|
      if @transportation_express.save
        format.html { redirect_to @transportation_express, notice: 'Transportation express was successfully created.' }
        format.json { render :show, status: :created, location: @transportation_express }
      else
        format.html { render :new }
        format.json { render json: @transportation_express.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  # 本人確認処理
  #
  def check_proc
    init
    @transportation_expresses.update_all(["self_approved = ?",true])

    init true
    create_transportation_expresses true
  end

  #
  # 本人確認取消
  #
  def cancel_check_proc
    init
    @transportation_expresses.update_all(["self_approved = ?",false])
  end

  #
  # 上長承認処理
  #
  def approve_proc
    init
    @transportation_expresses.update_all(["boss_approved = ?",true])
  end

  #
  # 上長承認取消
  #
  def cancel_approval_proc
    init
    @transportation_expresses.update_all(["boss_approved = ?",false])
  end

  # PATCH/PUT /transportation_expresses/1
  # PATCH/PUT /transportation_expresses/1.json
  def update
    respond_to do |format|
      if @transportation_express.update(transportation_express_params)
        format.html { redirect_to @transportation_express, notice: 'Transportation express was successfully updated.' }
        format.json { render :show, status: :ok, location: @transportation_express }
      else
        format.html { render :edit }
        format.json { render json: @transportation_express.errors, status: :unprocessable_entity }
      end
    end
    session[:date] = @transportation_express.updated_at
  end

  # DELETE /transportation_expresses/1
  # DELETE /transportation_expresses/1.json
  def destroy
    @transportation_express.destroy
    respond_to do |format|
      format.html { redirect_to transportation_expresses_url, notice: 'Transportation express was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transportation_express
      @transportation_express = TransportationExpress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transportation_express_params
      params.require(:transportation_express).permit(:user_id, :koutu_date, :destination, :route, :transport, :money, :note, :sum, :year,:day, :month)
    end



    # =================================================================================================-
    #
  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_transportation_express_years?
      session[:years] = params[:paper][:years]
    end

    @transportation_express_years = get_years(current_user.transportation_expresses, freezed)
    
    @nendo = get_nendo(@transportation_express_years)
    @gatudo = get_gatudo(@transportation_express_years)
    @project = get_project

    @transportation_expresses = current_user.transportation_expresses.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)

    
  end



  def create_transportation_expresses(freezed=false)

    if @transportation_expresses.exists?
      @freezed = @transportation_expresses.first.freezed
      create_years_collection current_user.transportation_expresses, freezed
      return
    end

    if !@transportation_expresses.exists?
      target_date = Date.new(@transportation_express_years.year, get_month(@transportation_express_years), 16)
      

      @transportation_express = current_user.transportation_expresses.build
      @transportation_express[:year] = @nendo
      @transportation_express[:month] = @gatudo
      if @transportation_express.save
        @transportation_expresses << @transportation_express
        target_date = target_date.tomorrow
      end
    end

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
  def create_transportation_express_years(freezed=false)
    @nen_gatudo = current_user.transportation_expresses.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

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
  def changed_transportation_express_years?
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
  def get_transportation_express_years(transportation_express, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    else
      temp = current_user.transportation_expresses.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
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


# ===========================================================================================================---


end
