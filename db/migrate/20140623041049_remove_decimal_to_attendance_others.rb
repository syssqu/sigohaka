class RemoveDecimalToAttendanceOthers < ActiveRecord::Migration
  def change
    remove_column :attendance_others, :decimal
  end
end
