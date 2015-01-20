class CreateTimeLines < ActiveRecord::Migration
  def change
    create_table :time_lines do |t|
      t.string :title
      t.text :contents
      t.integer :user_id
      t.integer :create_user_id

      t.timestamps
    end
  end
end
