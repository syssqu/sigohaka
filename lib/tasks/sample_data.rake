# -*- coding: utf-8 -*-
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Section.create!(code: "1", name: "システム事業部1課")
    Section.create!(code: "2", name: "システム事業部2課")
    Section.create!(code: "3", name: "システム事業部3課")

    admin = User.create!(family_name: "中村",
                 first_name: "淳一郎",
                 kana_family_name: "ナカムラ",
                 kana_first_name: "ジュンイチロウ",
                 email: "njsekay@gmail.com",
                 password: "hydeouT4342",
                 gender: :man,
                 section_id: 2,
                 birth_date: "1979/6/28",
                 age:34,
                 postal_code:"587-0003",
                 prefecture: "大阪府",
                 city: "堺市美原区阿弥364-20",
                 phone: "080-4396-2818",
                 employee_no: "020401",
                 experience: 13,
                 gakureki: "H14.03 京都産業大学 理学部",
                 role: "admin"
      )

    admin.projects.create!(start_date:"2014/01/01", end_date:"2014/05/30", summary: "社内研修・HP作成", active: true)
    admin.projects.create!(start_date:"2014/06/01", end_date:"", summary: "自社グループウェアの作成", active: false)

    admin.licenses.create!(code: "1", name:"基本情報処理")
    admin.licenses.create!(code: "2", name:"応用情報処理")
    
    admin.kinmu_patterns.create!(code: "1", start_time:"9:00", end_time:"18:00", break_time: 1.00, work_time: 8.00)
    admin.kinmu_patterns.create!(code: "2")
    admin.kinmu_patterns.create!(code: "3")

    admin.attendance_others.create!(summary: "課会", start_time: "19:30", end_time: "20:30", work_time: 1.00, remarks: "XXX実施")
    admin.attendance_others.create!(summary: "全体会")
    admin.attendance_others.create!(summary: "")
  end
end
