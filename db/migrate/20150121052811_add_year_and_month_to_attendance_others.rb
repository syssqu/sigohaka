class AddYearAndMonthToAttendanceOthers < ActiveRecord::Migration
  def change
    add_column :attendance_others, :year, :string, limit:4
    add_column :attendance_others, :month, :string, limit:2
  end
end
