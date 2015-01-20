class RenamePatternToRoleInUser < ActiveRecord::Migration
  def change
    rename_column :katagakis, :pattern, :role
  end
end
