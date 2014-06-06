class ModifyDecimalScaleToAttendance < ActiveRecord::Migration
  def change
    change_column :Attendances, :over_time, :decimal, :precision => 4, :scale => 2
    change_column :Attendances, :holiday_time, :decimal, :precision => 4, :scale => 2
    change_column :Attendances, :midnight_time, :decimal, :precision => 4, :scale => 2
    change_column :Attendances, :break_time, :decimal, :precision => 4, :scale => 2
    change_column :Attendances, :kouzyo_time, :decimal, :precision => 4, :scale => 2
    change_column :Attendances, :work_time, :decimal, :precision => 4, :scale => 2
  end
end
