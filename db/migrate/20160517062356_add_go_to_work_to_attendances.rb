class AddGoToWorkToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :go_to_work, :boolean, default: false, null: false
    add_column :attendances, :leave_work, :boolean, default: false, null: false
  end
end
