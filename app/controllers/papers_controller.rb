# -*- coding: utf-8 -*-
class PapersController < ApplicationController
  attr_accessor :title, :years

  def index_freeze
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
  def create_years_collection(objects, freezed=false)
    @years = objects.select("year ||  month as id, year || '年' || month || '月度' as value").group('year, month').order("id DESC")

    if freezed
      temp = session[:years]
      
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
      next_years = years.months_since(1)
      
      session[:years] = "#{next_years.year}#{next_years.month}"
    end
  end

  # 画面に出力する勤怠日付を確定する
  # 締め処理の場合
  #   対象年月の翌月を返す
  # それ以外の場合
  #   対象年月を返す
  # @param [Object] objects
  # @param [Boolean] freezed 呼び出し元が締め処理の場合にtrueを設定する。選択する対象年月を翌月に変更する。
  # @return [Date] 対象勤怠日付
  def get_years(objects, freezed=false)
    
    unless session[:years].blank?
      temp = session[:years]
      years = Date.new(temp[0..3].to_i, temp[4..-1].to_i, 1)
    else
      temp = objects.select('year, month').where("freezed = ? and self_approved = ? and boss_approved = ?", false, false, false).group('year, month').order('year, month')
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
