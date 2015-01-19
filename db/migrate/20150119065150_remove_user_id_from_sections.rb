class RemoveUserIdFromSections < ActiveRecord::Migration
  def change
    remove_column :sections, :user_id, :integer
  end
end
