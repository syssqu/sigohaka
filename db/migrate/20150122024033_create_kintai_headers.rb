class CreateKintaiHeaders < ActiveRecord::Migration
  def change
    create_table :kintai_headers do |t|
      t.string :year, limit:4
      t.string :month, limit:2
      t.string :user_name
      t.string :section_name
      t.string :project_name
      t.integer :user_id

      t.timestamps
    end
  end
end
