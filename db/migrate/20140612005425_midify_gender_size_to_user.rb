class MidifyGenderSizeToUser < ActiveRecord::Migration
  def change
    change_column :users, :gender, :string, limit: 10
  end
end
