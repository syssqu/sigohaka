class AddStationToUser < ActiveRecord::Migration
  def change
    add_column :users, :station, :string
  end
end
