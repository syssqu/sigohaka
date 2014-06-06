class AddHolidayToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :holiday, :string, limit: 1
  end
end
