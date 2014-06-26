class AddRegistrationNoIndividualToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :registration_no_individual, :integer
  end
end
