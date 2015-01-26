# -*- coding: utf-8 -*-
class PapersController < ApplicationController
  attr_accessor :title, :years

  def index_freeze
  end

  #
  # 初期化
  #
  def init(target, freezed)
    logger.debug("PapersController::init")

    # 対象年月
    if YearsController.changed_years_list?(params[:paper])
      session[:years] = params[:paper][:years]
    end
    
    # 対象ユーザー
    session[:target_user] ||= current_user.id
    if YearsController.changed_users_list?(params[:user])
      session[:target_user] = params[:user][:id]
    end

    @target_years = get_years(target, freezed)
    
    @nendo = YearsController.get_target_year(@target_years)
    @gatudo = YearsController.get_gatudo(@target_years)
    @project = get_project
    
    session[:years] ||= "#{@nendo}#{@gatudo}"
  end

  #
  # 凍結情報をセットする
  #
  def set_freeze_info(target)

    logger.debug("set_freeze_info")
    
    if view_context.be_self target.first
      @freezed = target.first.self_approved or target.first.boss_approved
    else
      @freezed = target.first.boss_approved
    end
  end

  #
  # ステータスをセットする
  #
  def set_status(target)
    @status = "本人未確認"
    if target.first.boss_approved
      @status = "上長承認済み"
    elsif target.first.self_approved
      @status = "本人確認済み"
    end
  end

  #
  # 印刷処理
  #
  def print
    print_proc
    
    respond_to do |format|
      format.html { redirect_to :action=> 'print',format: :pdf, debug: 1}
      format.pdf do
        render pdf: @title,
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  #
  # 基本情報のセット
  #
  def setBasicInfo
    if session[:years].nil?
      redirect_to :index
    end

    @nendo = session[:years][0..3].to_i
    @gatudo = session[:years][4..5].to_i
    @project = get_project
  end

  #
  # 締め処理
  #
  def freeze_up
    
    ActiveRecord::Base.transaction do
      freeze_up_proc
      # init
      # @attendances.update_all(["freezed = ?",true])

      # init true
      # create_attendances true
    end

    redirect_to ({action: :index_freeze}), :notice => '締め処理を完了しました。'
    
  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
  end

  #
  # 締め取消し処理
  #
  def cancel_freeze
    ActiveRecord::Base.transaction do
      cancel_freeze_proc
      # init
      # @attendances.update_all(["freezed = ?",false])
    end

    redirect_to ({action: :index_freeze}), :notice => '締め処理を取り消しました。'

  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
  end

  #
  # 上長承認処理
  #
  def approve
    ActiveRecord::Base.transaction do
      approve_proc
    end

    redirect_to ({action: :index}), :notice => '上長承認を行いました。'
  end

  #
  # 上長破棄処理
  #
  def cancel_approval
    ActiveRecord::Base.transaction do
      cancel_approval_proc
    end

    redirect_to ({action: :index}), :notice => '上長承認を取り消しました。'

  end

  #
  # 本人確認処理
  #
  def check
    ActiveRecord::Base.transaction do
      check_proc
    end

    # 対象年月を翌月に設定する
    temp_years = YearsController.next_years(session[:years])
    unless temp_years.blank?
      session[:years] = temp_years
    end

    redirect_to ({action: :index}), :notice => '本人確認を行いました。'
    
  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
  end

  #
  # 本人未確認処理
  #
  def cancel_check
    ActiveRecord::Base.transaction do
      cancel_check_proc
    end

    redirect_to ({action: :index}), :notice => '本人確認を取り消しました。'

  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
    
  end

  protected

  def print_proc
  end
  
  def freeze_up_proc
  end

  def cancel_freeze_proc
  end

  def approve_proc
  end
  
  def cancel_approval_proc
  end
  
  def check_proc
  end

  def cancel_check_proc
  end
  
  #
  # 対象年月のセレクトボックス内に含めるデータを作成する
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @param [Object] objects
  #
  # def create_years_collection(objects, freezed=false)
  #   @years = objects.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

  #   if freezed
  #     temp = session[:years]
      
  #     years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
  #     next_years = years.next_month
      
  #     session[:years] = "#{next_years.year}#{next_years.month}"
  #   end
  # end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   対象年月の翌月を返す
  # それ以外の場合
  #   対象年月を返す
  # @param [Object] objects
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @return [Date] 対象勤怠日付
  def get_years(objects, freezed=false)
    
    unless session[:years].nil?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..5].to_i, 1)
    else
      temp = objects.select('year, month').where("freezed = ? and self_approved = ? and boss_approved = ?", false, false, false).group('year, month').order('year, month')
      if temp.exists?
        years = Date.new(temp.first.year.to_i, temp.first.month.to_i, 1)
      else
        years = Date.today
      end
    end

    if freezed
      years.next_month
    else
      years
    end
  end

  # タイムラインへの投稿(本人確認)
  def posting_check_proc(target)
    # 自分のタイムラインへ本人確認済みを表示させる
    @time_line = current_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 本人確認実施"
    @time_line[:contents] = target + "の本人確認を完了しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!

    # マネージャーのタイムラインへ上長承認依頼を表示させる
    temp_user = getManager
    @time_line = temp_user[0].time_lines.build
    
    @time_line[:title] = "[勤怠管理] 上長承認依頼"
    @time_line[:contents] = current_user.family_name + " " + current_user.first_name + "さんが" + target + "の本人確認を完了しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!
  end

  # タイムラインへの投稿(本人確認取消)
  def posting_cancel_check_proc(target)
    # 自分のタイムラインへ本人確認済みを表示させる
    @time_line = current_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 本人確認取消"
    @time_line[:contents] = target + "の本人確認を取消しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!

    # マネージャーのタイムラインへ上長承認依頼を表示させる
    temp_user = getManager
    @time_line = temp_user[0].time_lines.build

    @time_line[:title] = "[勤怠管理] 上長承認依頼取消"
    @time_line[:contents] = current_user.family_name + " " + current_user.first_name + "さんが" + target + "の本人確認を取消しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!
  end

  # タイムラインへの投稿(上長承認)
  def posting_approve_proc(target, target_user)
    # 自分のタイムラインへ上長承認済みを表示させる
    @time_line = current_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 上長承認"
    @time_line[:contents] = target_user.family_name + " " + target_user.first_name + "さんの" + target + "を承認しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!

    # 社員のタイムラインへ上長承認依頼を表示させる
    @time_line = target_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 上長承認完了"
    @time_line[:contents] = target + "が承認されました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!
  end

  # タイムラインへの投稿(上長承認)
  def posting_cancel_approve_proc(target, target_user)
    # 自分のタイムラインへ上長承認取消を表示させる
    @time_line = current_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 上長承認取消"
    @time_line[:contents] = target_user.family_name + " " + target_user.first_name + "さんの" + target + "の承認を取消しました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!

    # 社員のタイムラインへ上長承認依頼を表示させる
    @time_line = target_user.time_lines.build
    @time_line[:title] = "[勤怠管理] 上長承認取消"
    @time_line[:contents] = target + "の承認が取消されました。"
    @time_line[:create_user_id] = current_user.id
    @time_line.save!
  end
  
  #
  # 勤怠ヘッダーの作成
  #
  def create_kintai_header

    logger.info("create_kintai_header")

    if view_context.target_user.kintai_headers.exists?(year: @nendo.to_s,month: @gatudo.to_s)
      return
    end
    
    # ヘッダー情報(ユーザー名、所属、プロジェクト名)の登録
    kintai_header = view_context.target_user.kintai_headers.build
    kintai_header[:year] = @nendo
    kintai_header[:month] = @gatudo
    kintai_header[:user_name] = "#{view_context.target_user.family_name} #{view_context.target_user.first_name}"
    kintai_header[:section_name] = view_context.target_user.section.name unless view_context.target_user.section.blank?

    @project = get_project
    kintai_header[:project_name] = @project.summary unless @project.blank?
    
    unless kintai_header.save
      logger.debug("勤怠ヘッダ登録処理エラー")
    end

    @kintai_header = view_context.target_user.kintai_headers.find_by(year: @nendo.to_s,month: @gatudo.to_s)
  end
end
