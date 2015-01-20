class AddColumnToHousingAllowance < ActiveRecord::Migration
  def change
    add_column :housing_allowances, :freezed, :boolean
    add_column :housing_allowances, :self_approved, :boolean
    add_column :housing_allowances, :boss_approved, :boolean
  end
end
