class AddColumnToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :year, :string, limit:4
    add_column :qualification_allowances, :month, :string, limit:2
  end
end
