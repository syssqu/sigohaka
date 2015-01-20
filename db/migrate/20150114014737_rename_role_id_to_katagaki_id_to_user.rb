class RenameRoleIdToKatagakiIdToUser < ActiveRecord::Migration
  def change
    rename_column :users, :role_id, :katagaki_id
  end
end
