class RenameRoleToKatagaki < ActiveRecord::Migration
  def change
    rename_table :Roles, :Katagakis
  end
end
