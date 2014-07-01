class AddColumnToSummaryAttendance < ActiveRecord::Migration
  def change
    add_column :summary_attendances, :note, :string
  end
end
