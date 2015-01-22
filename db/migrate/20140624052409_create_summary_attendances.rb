class CreateSummaryAttendances < ActiveRecord::Migration
  def change
    create_table :summary_attendances do |t|
      t.integer :user_id
      t.string :year, limit: 4
      t.string :month, limit: 2
      t.decimal :previous_m
      t.decimal :present_m
      t.integer :vacation
      t.integer :half_holiday

      t.timestamps
    end
  end
end
