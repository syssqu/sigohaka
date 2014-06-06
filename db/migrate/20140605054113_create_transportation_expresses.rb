class CreateTransportationExpresses < ActiveRecord::Migration
  def change
    create_table :transportation_expresses do |t|
      t.integer :user_id
      t.date :koutu_date
      t.string :destination
      t.string :route
      t.string :transport
      t.integer :money
      t.string :note
      t.integer :sum
      t.string :year, limit: 4
      t.string :month, limit: 2

      t.timestamps
    end
  end
end
