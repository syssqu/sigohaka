# -*- coding: utf-8 -*-
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Section.create!(code: "1", name: "システム事業部1課")
    Section.create!(code: "2", name: "システム事業部2課")
    Section.create!(code: "3", name: "システム事業部3課")
    
    User.create!(family_name: "中村",
                 first_name: "淳一郎",
                 kana_family_name: "ナカムラ",
                 kana_first_name: "ジュンイチロウ",
                 email: "njsekay@gmail.com",
                 password: "hydeouT4342",
                 password_confirmation: "hydeouT4342",
                 section_id: 2
      )
    
    9.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      User.create!(family_name: Faker::Name::last_name,first_name: Faker::Name::first_name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   section_id: 1)
    end
  end
end
