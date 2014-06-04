class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.date :attendance_date
      t.string :year
      t.string :month
      t.string :day
      t.string :wday
      t.string :pattern
      t.time :start_time
      t.time :end_time
      t.boolean :byouketu
      t.boolean :kekkin
      t.boolean :hankekkin
      t.boolean :titoku
      t.boolean :soutai
      t.boolean :gaisyutu
      t.boolean :tokkyuu
      t.boolean :furikyuu
      t.boolean :yuukyuu
      t.boolean :syuttyou
      t.integer :over_time
      t.integer :holiday_time
      t.integer :midnight_time
      t.integer :break_time
      t.integer :kouzyo_time
      t.integer :work_time
      t.text :remarks
      t.integer :user_id

      t.timestamps
    end
  end
end
