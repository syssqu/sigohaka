class ChangeRoleTypeOfKatagaki < ActiveRecord::Migration
  def change
    change_column :katagakis, :role, :string
  end
end
