class ModifyDecimalFromIntegerToAttendance < ActiveRecord::Migration
  def change
    change_column :attendances, :over_time, :decimal
    change_column :attendances, :holiday_time, :decimal
    change_column :attendances, :midnight_time, :decimal
    change_column :attendances, :break_time, :decimal
    change_column :attendances, :kouzyo_time, :decimal
    change_column :attendances, :work_time, :decimal
  end
end
