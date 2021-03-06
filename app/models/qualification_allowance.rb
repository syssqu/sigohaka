class QualificationAllowance < ActiveRecord::Base
	belongs_to :user

  ITEM = 
    [["A1 : ITストラテジスト","ITストラテジスト"],
     ["A2 : システム監査技術者","システム監査技術者"],
     ["A3 : システムアーキテクト","システムアーキテクト"],
     ["A4 : 応用情報技術者","応用情報技術者"],
     ["A5 : プロジェクトマネージャー","プロジェクトマネージャー"],
     ["A6 : ネットワークスペシャリスト","ネットワークスペシャリスト"],
     ["A7 : データベーススペシャリスト","データベーススペシャリスト"],
     ["A8 : エンベンデットシステムスペシャリスト","エンベンデットシステムスペシャリスト"],
     ["A9 : 情報セキュリティースペシャリスト","情報セキュリティースペシャリスト"],
     ["A10 : ITサービスマネーシャー","ITサービスマネーシャー"],
     ["A11 : 基本情報技術者","基本情報技術者"],
     ["A12 : ITパスポート","ITパスポート"]]

  NUMBER = 
    [["A1 : ITストラテジスト","A1"],
     ["A2 : システム監査技術者","A2"],
     ["A3 : システムアーキテクト","A3"],
     ["A4 : 応用情報技術者","A4"],
     ["A5 : プロジェクトマネージャー","A5"],
     ["A6 : ネットワークスペシャリスト","A6"],
     ["A7 : データベーススペシャリスト","A7"],
     ["A8 : エンベンデットシステムスペシャリスト","A8"],
     ["A9 : 情報セキュリティースペシャリスト","A9"],
     ["A10 : ITサービスマネーシャー","A10"],
     ["A11 : 基本情報技術者","A11"],
     ["A12 : ITパスポート","A12"]]

  MONEY = 
    [["A1~A3 : 30000 円","30000"],
     ["A4~A10 : 20000 円","20000"],
     ["A11 : 10000 円","10000"],
     ["A12 : 3000 円","3000"]]

  ALPHABET = 
    [["ST","ST"],
     ["AU","AU"],
     ["SA","SA"],
     ["AP","AP"],
     ["PM","PM"],
     ["NW","NW"],
     ["DB","DB"],
     ["ES","ES"],
     ["SC","SC"],
     ["SM","SM"],
     ["FE","FE"],
     ["IP","IP"]]
end
