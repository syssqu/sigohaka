# -*- coding: utf-8 -*-
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    Section.create!(code: "1", name: "システム事業部1課")
    Section.create!(code: "2", name: "システム事業部2課")
    Section.create!(code: "3", name: "システム事業部3課")

    Katagaki.create!(name: "管理者", role: "admin")
    Katagaki.create!(name: "マネージャー", role: "manager")
    Katagaki.create!(name: "一般", role: "regular")

    TimeLine.create!(title: "ようこそ", contents: "どうぞ宜しく", user_id: 1)
    TimeLine.create!(title: "ようこそ", contents: "どうぞ宜しく", user_id: 2)
    TimeLine.create!(title: "ようこそ", contents: "どうぞ宜しく", user_id: 3)

    ##############################
    # 中村
    ##############################
    admin = User.create!(family_name: "中村",
                 first_name: "淳一郎",
                 kana_family_name: "ナカムラ",
                 kana_first_name: "ジュンイチロウ",
                 email: "njsekay@gmail.com",
                 password: "systemsquare",
                 gender: :man,
                 section_id: 2,
                 birth_date: "1979/6/28",
                 age:34,
                 postal_code:"",
                 prefecture: "",
                 city: "大阪府堺市",
                 phone: "",
                 employee_no: "020401",
                 experience: 13,
                 gakureki: "H14.03 京都産業大学 理学部",
                 station: "南海 高野線 北野田駅",
                 employee_date: "2002/4/1",
                 imprint_id: "j-nakamura",
                 katagaki_id:2
      )

    admin.projects.create!(start_date:"2014/01/01", end_date:"2014/05/30", summary: "社内研修・HP作成", active: true)
    admin.projects.create!(start_date:"2014/06/01", end_date:"", summary: "自社グループウェアの作成", active: false)

    admin.licenses.create!(code: "1", name:"基本情報処理")
    admin.licenses.create!(code: "2", name:"応用情報処理")

    admin.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    admin.kinmu_patterns.create!(code: "2")
    admin.kinmu_patterns.create!(code: "3")
    admin.kinmu_patterns.create!(code: "4")
    admin.kinmu_patterns.create!(code: "5")
    admin.kinmu_patterns.create!(code: "*")

    ##############################
    # 幡山
    ##############################
    hatayama = User.create!(family_name: "幡山",
                 first_name: "雄平",
                 kana_family_name: "ハタヤマ",
                 kana_first_name: "ユウヘイ",
                 email: "a@a.c",
                 password: "sigohaka",
                 gender: :man,
                 section_id: 2,
                 katagaki_id:2
      )

    hatayama.projects.create!(start_date:"2014/01/01", end_date:"2014/05/30", summary: "社内研修・HP作成", active: true)
    hatayama.projects.create!(start_date:"2014/06/01", end_date:"", summary: "自社グループウェアの作成", active: false)

    hatayama.licenses.create!(code: "1", name:"基本情報処理")
    hatayama.licenses.create!(code: "2", name:"応用情報処理")

    hatayama.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    hatayama.kinmu_patterns.create!(code: "2")
    hatayama.kinmu_patterns.create!(code: "3")

    # hatayama.attendance_others.create!(summary: "課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
    # hatayama.attendance_others.create!(summary: "全体会")
    # hatayama.attendance_others.create!(summary: "")

    # 5.times do |m|
    #   3.times do |n|
    #     TransportationExpress.create!(user_id: "#{n}",
    #                             koutu_date: "2014-06-01",
    #                             destination: "大阪#{n}",
    #                             route: "東京ー＞大阪#{n}",
    #                             transport: "JR#{n}",
    #                             money: "#{n+m}",
    #                             note: Faker::Lorem.sentence(5)
    #                             )
    #   end
    # end


    ##############################
    # 井角
    ##############################
    isumi = User.create!(family_name: "井角",
                 first_name: "公亮",
                 kana_family_name: "イスミ",
                 kana_first_name: "コウスケ",
                 email: "k-isumi@sys-square.co.jp",
                 password: "ki7777777",
                 gender: :man,
                 section_id: 2,
                 katagaki_id:1
      )

    isumi.projects.create!(start_date:"2014/01/01", end_date:"2014/05/30", summary: "社内研修・HP作成", active: true)
    isumi.projects.create!(start_date:"2014/06/01", end_date:"", summary: "自社グループウェアの作成", active: false)

    isumi.licenses.create!(code: "1", name:"基本情報処理")
    isumi.licenses.create!(code: "2", name:"応用情報処理")

    isumi.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    isumi.kinmu_patterns.create!(code: "2")
    isumi.kinmu_patterns.create!(code: "3")

    # isumi.attendance_others.create!(summary: "課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
    # isumi.attendance_others.create!(summary: "全体会")
    # isumi.attendance_others.create!(summary: "")

    ##############################
    # テスト管理者
    ##############################
    admin = User.create!(family_name: "テスト",
                 first_name: "管理者",
                 kana_family_name: "テスト",
                 kana_first_name: "カンリシャ",
                 email: "root@gmail.com",
                 password: "rootroot",
                 gender: :man,
                 section_id: 2,
                 birth_date: "1979/6/28",
                 age:34,
                 postal_code:"",
                 prefecture: "",
                 city: "大阪府堺市",
                 phone: "",
                 employee_no: "020401",
                 experience: 13,
                 gakureki: "H14.03 京都産業大学 理学部",
                 station: "南海 高野線 北野田駅",
                 employee_date: "2002/4/1",
                 imprint_id: "j-nakamura",
                 katagaki_id:2
      )

    admin.projects.create!(start_date:"2014/01/01", end_date:"2014/05/30", summary: "社内研修・HP作成", active: true)
    admin.projects.create!(start_date:"2014/06/01", end_date:"", summary: "自社グループウェアの作成", active: false)

    admin.licenses.create!(code: "1", name:"基本情報処理")
    admin.licenses.create!(code: "2", name:"応用情報処理")

    admin.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    admin.kinmu_patterns.create!(code: "2")
    admin.kinmu_patterns.create!(code: "3")
    admin.kinmu_patterns.create!(code: "*")

    # admin.attendance_others.create!(summary: "課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "")
    # admin.attendance_others.create!(summary: "全体会")
    # admin.attendance_others.create!(summary: "")


    ##############################
    # 大谷
    ##############################
    isumi = User.create!(family_name: "大谷",
                 first_name: "誘規",
                 kana_family_name: "オオタニ",
                 kana_first_name: "ユウキ",
                 email: "y-ootani@sys-square.co.jp",
                 password: "systemsquare",
                 gender: :man,
                 section_id: 2,
                 katagaki_id:1
      )

    isumi.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    isumi.kinmu_patterns.create!(code: "2")
    isumi.kinmu_patterns.create!(code: "3")

    ##############################
    # 東川
    ##############################
    isumi = User.create!(family_name: "東川",
                 first_name: "育実",
                 kana_family_name: "トガワ",
                 kana_first_name: "イクミ",
                 email: "i-togawa@sys-square.co.jp",
                 password: "systemsquare",
                 gender: :woman,
                 section_id: 2,
                 katagaki_id:1
      )

    isumi.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    isumi.kinmu_patterns.create!(code: "2")
    isumi.kinmu_patterns.create!(code: "3")

    ##############################
    # 大谷
    ##############################
    isumi = User.create!(family_name: "幸地",
                 first_name: "隆",
                 kana_family_name: "コウチ",
                 kana_first_name: "タカシ",
                 email: "t-kouchi@sys-square.co.jp",
                 password: "systemsquare",
                 gender: :man,
                 section_id: 2,
                 katagaki_id:1
      )

    isumi.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    isumi.kinmu_patterns.create!(code: "2")
    isumi.kinmu_patterns.create!(code: "3")
  end
end
