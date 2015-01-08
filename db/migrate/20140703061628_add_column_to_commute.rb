class AddColumnToCommute < ActiveRecord::Migration
  def change
    add_column :commutes, :freezed, :boolean
    add_column :commutes, :self_approved, :boolean
    add_column :commutes, :boss_approved, :boolean
  end
end
