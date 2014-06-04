class CreateKinmuPatterns < ActiveRecord::Migration
  def change
    create_table :kinmu_patterns do |t|
      t.time :start_time
      t.time :end_time
      t.integer :break_time
      t.integer :work_time
      t.integer :user_id

      t.timestamps
    end
  end
end
