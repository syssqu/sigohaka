class RenameRoleToKatagaki < ActiveRecord::Migration
  def change
    rename_table :roles, :katagakis
  end
end
