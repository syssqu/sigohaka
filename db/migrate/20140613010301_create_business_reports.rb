class CreateBusinessReports < ActiveRecord::Migration
  def change
    create_table :business_reports do |t|
      t.integer :user_id
      t.text :naiyou
      t.text :jisseki
      t.string :tool
      t.string :self_purpose
      t.string :self_value
      t.string :self_reason
      t.text :user_situation
      t.text :request
      t.string :develop_purpose
      t.text :develop_jisseki
      t.text :note

      t.timestamps
    end
  end
end
