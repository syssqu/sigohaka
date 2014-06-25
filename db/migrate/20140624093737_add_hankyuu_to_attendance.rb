class AddHankyuuToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :hankyuu, :boolean, default: false
    add_column :attendances, :self_approved, :boolean, default: false
    add_column :attendances, :boss_approved, :boolean, default: false
    add_column :attendances, :freezed, :boolean, default: false
  end
end
