# -*- coding: utf-8 -*-
module ApplicationHelper

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
end
