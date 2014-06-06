class AddVariousColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string, limit: 1
    add_column :users, :birth_date, :date
    add_column :users, :employee_no, :string, limit: 6
    add_column :users, :age, :integer
    add_column :users, :experience, :integer
    add_column :users, :postal_code, :string, limit: 8
    add_column :users, :prefecture, :string
    add_column :users, :city, :string, limit: 80
    add_column :users, :house_number, :string, limit: 80
    add_column :users, :building, :string, limit: 80
    add_column :users, :phone, :string, limit: 13
    add_column :users, :gakureki, :string
    add_column :users, :remarks, :text
  end
end
