class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.integer :user_id
      t.string :reason
      t.string :reason_text
      t.string :year, limit: 4
      t.string :month, limit: 2

      t.timestamps
    end
  end
end
