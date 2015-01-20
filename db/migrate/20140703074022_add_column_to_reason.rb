class AddColumnToReason < ActiveRecord::Migration
  def change
    add_column :reasons, :freezed, :boolean
    add_column :reasons, :self_approved, :boolean
    add_column :reasons, :boss_approved, :boolean
  end
end
