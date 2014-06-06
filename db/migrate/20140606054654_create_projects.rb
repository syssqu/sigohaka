class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :summary
      t.text :description
      t.string :os
      t.string :language
      t.string :database
      t.string :dep_size
      t.string :role
      t.string :experience
      t.text :remarks
      t.integer :user_id

      t.timestamps
    end
  end
end
