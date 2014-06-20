class CreateCommutes < ActiveRecord::Migration
  def change
    create_table :commutes do |t|
      t.integer :user_id
      t.string :year, limit: 4
      t.string :month, limit: 2
      t.string :reason
      t.string :reason_text
      t.string :transport
      t.string :segment1
      t.string :segment2
      t.integer :money

      t.timestamps
    end
  end
end
