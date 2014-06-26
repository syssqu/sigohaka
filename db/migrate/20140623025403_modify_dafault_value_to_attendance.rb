class ModifyDafaultValueToAttendance < ActiveRecord::Migration
  def change
    change_column_default :attendances, :over_time, 0.00
    change_column_default :attendances, :holiday_time, 0.00
    change_column_default :attendances, :midnight_time, 0.00
    change_column_default :attendances, :break_time, 0.00
    change_column_default :attendances, :kouzyo_time, 0.00
    change_column_default :attendances, :work_time, 0.00
    change_column_default :attendances, :byouketu, false
    change_column_default :attendances, :kekkin, false
    change_column_default :attendances, :hankekkin, false
    change_column_default :attendances, :tikoku, false
    change_column_default :attendances, :soutai, false
    change_column_default :attendances, :gaisyutu, false
    change_column_default :attendances, :tokkyuu, false
    change_column_default :attendances, :furikyuu, false
    change_column_default :attendances, :yuukyuu, false
    change_column_default :attendances, :syuttyou, false
    change_column_default :attendances, :holiday, "0"
  end
end
