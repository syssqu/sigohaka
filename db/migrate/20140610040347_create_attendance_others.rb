class CreateAttendanceOthers < ActiveRecord::Migration
  def change
    create_table :attendance_others do |t|
      t.string :summary
      t.time :start_time
      t.time :end_time
      t.decimal :over_time, :precision => 4, :scale => 2
      t.decimal :holiday_time, :precision => 4, :scale => 2
      t.decimal :midnight_time, :precision => 4, :scale => 2
      t.decimal :break_time, :precision => 4, :scale => 2
      t.decimal :kouzyo_time, :precision => 4, :scale => 2
      t.decimal :work_time, :precision => 4, :scale => 2
      t.text :remarks
      t.integer :user_id

      t.timestamps
    end
  end
end
