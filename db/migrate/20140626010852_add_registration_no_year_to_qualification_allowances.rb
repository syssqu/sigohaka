class AddRegistrationNoYearToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :registration_no_year, :integer
  end
end
