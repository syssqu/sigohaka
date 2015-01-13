class ChangeDatatypeStartTimeOfAttendance < ActiveRecord::Migration
  def change
    change_column :attendances, :start_time, :string, limit:5
    change_column :attendances, :end_time, :string, limit:5
  end
end
