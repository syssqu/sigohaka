# データ更新時の入力チェック
$("#submit").click ->
  if $("#attendance_other_over_time").val() == ""
    alert "超過時間を入力してください"
    return false
  if $("#attendance_other_holiday_time").val() == ""
    alert "休日時間を入力してください"
    return false
  if $("#attendance_other_midnight_time").val() == ""
    alert "深夜時間を入力してください"
    return false
  if $("#attendance_other_break_time").val() == ""
    alert "休憩時間を入力してください"
    return false
  if $("#attendance_other_kouzyo_time").val() == ""
    alert "控除時間を入力してください"
    return false
  if $("#attendance_other_work_time").val() == ""
    alert "実働時間を入力してください"
    return false
