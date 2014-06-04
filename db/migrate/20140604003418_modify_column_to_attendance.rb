class ModifyColumnToAttendance < ActiveRecord::Migration
  def change
    change_column :attendances, :year, :string, limit:4
    change_column :attendances, :month, :string, limit:2
    change_column :attendances, :day, :string, limit:2
    change_column :attendances, :wday, :string, limit:1
    change_column :attendances, :pattern, :string, limit:1
    add_index :attendances, [:user_id, :year, :month, :day]
  end
end
