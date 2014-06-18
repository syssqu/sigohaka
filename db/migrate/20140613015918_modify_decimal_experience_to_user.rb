class ModifyDecimalExperienceToUser < ActiveRecord::Migration
  def up
    change_column :users, :experience, :decimal, :precision => 5, :scale => 1
  end

  def down
    change_column :users, :experience, :integer
  end
end
