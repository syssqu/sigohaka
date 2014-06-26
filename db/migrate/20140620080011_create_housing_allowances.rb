class CreateHousingAllowances < ActiveRecord::Migration
  def change
    create_table :housing_allowances do |t|
      t.integer :user_id
      t.string :year, limit: 4
      t.string :month, limit: 2
      t.string :reason
      t.string :reason_text
      t.string :housing_style
      t.string :housing_style_text
      t.date :agree_date_s
      t.date :agree_date_e
      t.string :spouse
      t.string :spouse_name
      t.string :spouse_other
      t.string :support
      t.string :support_name1
      t.string :support_name2
      t.integer :money

      t.timestamps
    end
  end
end
