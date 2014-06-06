class ModifyDecimalFromIntegerToAttendance < ActiveRecord::Migration
  def change
    change_column :Attendances, :over_time, :decimal
    change_column :Attendances, :holiday_time, :decimal
    change_column :Attendances, :midnight_time, :decimal
    change_column :Attendances, :break_time, :decimal
    change_column :Attendances, :kouzyo_time, :decimal
    change_column :Attendances, :work_time, :decimal
  end
end
