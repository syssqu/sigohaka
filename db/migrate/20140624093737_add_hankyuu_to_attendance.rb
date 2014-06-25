class AddHankyuuToAttendance < ActiveRecord::Migration
  def change
    add_column :users, :hankyuu, :boolean, default: false
    add_column :users, :self_approved, :boolean, default: false
    add_column :users, :boss_approved, :boolean, default: false
    add_column :users, :freezed, :boolean, default: false
  end
end
