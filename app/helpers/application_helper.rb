# -*- coding: utf-8 -*-
module ApplicationHelper

  def target_user
    logger.debug("ApplicationHelper::target_user=")
    
    if session[:target_user].nil? or session[:target_user].blank?
      @target_user = current_user
    else
      @target_user = User.find(session[:target_user])
    end

    @target_user
  end

  # def target_user
  #   logger.debug("ApplicationHelper::target_user")
  #   @target_user
  #   logger.debug("@target_user: " + @target_user.id.to_s)
  # end
  
  # 指定された開始月から終了月までの月数を返す
  # @param [Date] start_date 開始月
  # @param [Date] end_date 終了月
  # @return [String] 月数
  def get_month_term(start_date, end_date)
    return "" if end_date.blank?
    ((end_date.year - start_date.year) * 12 + (end_date.month - start_date.month) + 1).to_s + "ヶ月"
  end

  # 西暦から和暦年を求めて返す
  # @param [Integer] year 年
  # @param [Integer] month 月
  # @param [Integer] day 日
  # @return [String] 和暦年 
  def seireki2wareki(year, month, day)
    wareki = ""
    
    if year == 1868
      #9月8日から明治元年
      wareki =  '明治元年'
      
    elsif 1868 < year and year < 1912
      
      year = year - 1867
      wareki =  "明治#{year}年"
      
    elsif year == 1912
      
      year = year - 1867
 
      # 明治46年7月30日まで明治
      # 明治46年7月31日から大正
      if month < 7 or (month == 7 and day < 31)
        wareki =  "明治#{year}年"
      else
        wareki =  '大正元年'
      end
      
    elsif 1912 < year and year < 1926
      
      year = year - 1911
      wareki =  "大正#{year}年"
      
    elsif year == 1926
      
      year = year - 1911
      
      if month < 12 or (month == 12 and day < 25)
        wareki =  "大正#{year}年"
      else
        wareki =  '昭和元年'
      end
      
    elsif 1926 < year and year < 1989
      
      year = year - 1925
      wareki =  "昭和#{year}年"
      
    elsif year == 1989
      
      year = year - 1925
      
      if month == 1 and day < 7
        wareki =  "昭和#{year}年"
      else
        wareki =  '平成元年'
      end
      
    elsif 1988 < year
      
      year = year - 1988
      wareki =  "平成#{year}年"
      
    else
      
      wareki =  '--年'
    end
    
    wareki
  end

  # http://gravatar.com/からGravatar画像を取得して返す
  # @param [User] user ユーザー
  # @param [Integer] size オプション、画像のサイズに随時変更するためのもの
  # @return [nil] 
  def gravatar_for(user, options = { size: 50 })
    if user.nil?
      user = current_user
    end
    
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.family_name + user.first_name, class: "gravatar")
  end

  def be_self(object)
    current_user.id == object.user_id
  end

  def role_info(role_name)
    result = ""
    
    $role_info.each do |r|
        if r[1] == role_name
          result = r[0]
        end 
    end
    
    result
  end
  
end
