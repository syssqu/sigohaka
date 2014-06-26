class AddGetDateToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :get_date, :date
  end
end
