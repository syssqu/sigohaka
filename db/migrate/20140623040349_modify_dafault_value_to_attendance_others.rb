class ModifyDafaultValueToAttendanceOthers < ActiveRecord::Migration
  def change
    change_column_default :attendance_others, :over_time, 0.00
    change_column_default :attendance_others, :holiday_time, 0.00
    change_column_default :attendance_others, :midnight_time, 0.00
    change_column_default :attendance_others, :break_time, 0.00
    change_column_default :attendance_others, :kouzyo_time, 0.00
    change_column_default :attendance_others, :work_time, 0.00
  end
end
