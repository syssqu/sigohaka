class AddRegistrationNoMonthToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :registration_no_month, :integer
  end
end
