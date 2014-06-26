class AddImprintToUser < ActiveRecord::Migration
  def change
    add_column :users, :imprint_id, :string
    add_column :users, :employee_date, :date
  end
end
