class AddColumnToVacationRequest < ActiveRecord::Migration
  def change
    add_column :vacation_requests, :self_approved, :boolean, default: false
    add_column :vacation_requests, :boss_approved, :boolean, default: false
    add_column :vacation_requests, :freezed, :boolean, default: false
  end
end
