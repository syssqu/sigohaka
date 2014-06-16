# -*- coding: utf-8 -*-
module ApplicationHelper

  def get_month_term(start_date, end_date)
    "" if end_date.blank?
    ((end_date.year - start_date.year) * 12 + (end_date.month - start_date.month) + 1).to_s + "ヶ月"
  end

  # 西暦から和暦を求めて年を返す
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

  # http://gravatar.com/からGravatarを取得して返す
  def gravatar_for(user, options = { size: 50 })
    if user.nil?
      user = current_user
    end
    
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.family_name + user.first_name, class: "gravatar")
  end
  
end
