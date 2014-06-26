class AddRegistrationNoAlphabetToQualificationAllowances < ActiveRecord::Migration
  def change
    add_column :qualification_allowances, :registration_no_alphabet, :string
  end
end
