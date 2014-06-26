class CreateQualificationAllowances < ActiveRecord::Migration
  def change
    create_table :qualification_allowances do |t|
      t.integer :user_id
      t.string :number
      t.string :item
      t.integer :money

      t.timestamps
    end
  end
end
