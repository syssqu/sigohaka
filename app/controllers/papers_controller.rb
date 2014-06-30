# -*- coding: utf-8 -*-
class PapersController < ApplicationController
  attr_accessor :title, :years

  #
  # 締め処理
  #
  def freeze_paper
    
    ActiveRecord::Base.transaction do
      freeze_proc
    end

    redirect_to ({action: :index}), :notice => '締め処理を完了しました。'
    
  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
  end

  def freeze_proc
  end

  #
  # 締め取消し処理
  #
  def unfreeze
    ActiveRecord::Base.transaction do
      unfreeze_proc
    end

    redirect_to ({action: :index}), :notice => '締め処理を取り消しました。'

  rescue => e
    render text: "以下のエラーが発生したため処理を中断しました<br><strong>エラー内容：" + e.message + "</strong><br>"
  end

  def unfreeze_proc
  end

  #
  # 印刷処理
  #
  def print
    respond_to do |format|
      format.html { redirect_to print_attendances_path(format: :pdf, debug: 1)}
      format.pdf do
        render pdf: @title,
               encoding: 'UTF-8',
               layout: 'pdf.html',
               show_as_html: params[:debug].present?
      end
    end
  end

  #
  # 上長承認処理
  #
  def approve
  end

  #
  # 上長破棄処理
  #
  def discard
  end

  #
  # 本人確認処理
  #
  def check
  end

  protected
  
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
      temp = objects.select('year, month').where("freezed = ?", false).group('year, month').order('year, month')
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
