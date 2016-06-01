class AddFreezedToSummaryAttendance < ActiveRecord::Migration
  def change
    add_column :summary_attendances, :self_approved, :boolean, default: false
    add_column :summary_attendances, :boss_approved, :boolean, default: false
    add_column :summary_attendances, :freezed, :boolean, default: false
  end
end
