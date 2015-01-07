class ReasonsController < PapersController
  before_action :set_reason, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!
  def edit
  end

  def new
    init
    @reason = Reason.new
  end

  def show
  end

  def create
    @reason = current_user.reasons.build(reason_params)

    respond_to do |format|
      if @reason.save
        format.html { redirect_to @reason, notice: 'Commute was successfully created.' }
        format.json { render :show, status: :created, location: @reason }
      else
        format.html { render :new }
        format.json { render json: @reason.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @reason.update(reason_params)
        format.html { redirect_to @reason, notice: 'Commute was successfully updated.' }
        format.json { render :show, status: :ok, location: @reason }
      else
        format.html { render :edit }
        format.json { render json: @reason.errors, status: :unprocessable_entity }
      end
    end
  end



  # 勤怠日付の初期化
  #
  def init(freezed=false)

    if changed_reason_years?
      session[:years] = params[:paper][:years]
    end

    @reason_years = get_years(current_user.reasons, freezed)
    
    @nendo = get_nendo(@reason_years)
    @gatudo = get_gatudo(@reason_years)
    @project = get_project

    @reasons = current_user.reasons.where("year = ? and month = ?", @nendo.to_s, @gatudo.to_s)
 
  end



  def set_reason
    @reason = Reason.find_by_id(params[:id])
    unless @reason then
  # 0件のときの処理
      redirect_to commutes_path
    end
  end

  def reason_params
    params.require(:reason).permit(:user_id, :year, :month, :reason, :reason_text)
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
  def changed_reason_years?
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
  def get_reason_years(reason, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
    else
      temp = current_user.reason.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
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
