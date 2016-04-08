class ModifyDecimalScaleToAttendance < ActiveRecord::Migration
  def change
    change_column :attendances, :over_time, :decimal, :precision => 4, :scale => 2
    change_column :attendances, :holiday_time, :decimal, :precision => 4, :scale => 2
    change_column :attendances, :midnight_time, :decimal, :precision => 4, :scale => 2
    change_column :attendances, :break_time, :decimal, :precision => 4, :scale => 2
    change_column :attendances, :kouzyo_time, :decimal, :precision => 4, :scale => 2
    change_column :attendances, :work_time, :decimal, :precision => 4, :scale => 2
  end
end
