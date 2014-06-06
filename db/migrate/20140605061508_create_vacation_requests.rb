class CreateVacationRequests < ActiveRecord::Migration
  def change
    create_table :vacation_requests do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.integer :term
      t.string :category
      t.string :reason
      t.string :note
      t.string :year
      t.string :month

      t.timestamps
    end
    add_index :vacation_requests, [:user_id, :year, :month]
  end
end
