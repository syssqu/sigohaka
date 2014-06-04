class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :family_name, :string, limit: 20
    add_column :users, :first_name, :string, limit: 20
    add_column :users, :kana_family_name, :string, limit: 40
    add_column :users, :kana_first_name, :string, limit: 40
  end
end
