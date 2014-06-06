class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :code
      t.string :name
      t.string :years
      t.integer :user_id

      t.timestamps
    end
  end
end
