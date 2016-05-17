# 勤務パターンが変更された際に出退勤時刻を変更する
$("#attendance_pattern").change ->

  $.ajax
    url: "/input_attendance_time"
    type: "GET"
    data:
      id: $("#target_id").val() # Attendance.find(params[:id])のため
      pattern: $("#attendance_pattern").val()
    dataType: "script"
    success: (data) ->
      return data
    error: (XMLHttpRequest, textStatus, errorThrown) ->

      msg = "--- Error Status ---"
      msg = msg + "<BR>" + "status:" + XMLHttpRequest.status
      msg = msg + "<BR>" + "statusText:" + XMLHttpRequest.statusText
      msg = msg + "<BR>" + "textStatus:" + textStatus
      msg = msg + "<BR>" + "errorThrown:" + errorThrown

      document.open()
      document.write msg
      document.close()
      return

# 区分や各時間を勤務パターンと出退勤時刻によって自動計算する
$("#calculate").click ->
  # if $("#attendance_pattern").val() == "" or $.trim($("#attendance_start_time").val()) == "" or $.trim($("#attendance_end_time").val()) == ""
  #   alert "勤務パターンと出退勤時間を入力して下さい。"
  #   return

  if $.trim($("#attendance_start_time").val()) != "" and ! $.trim($("#attendance_start_time").val()).match(/^\d{1,2}\:\d{2}$/)
    alert "出勤時刻が正しくありません。"
    return

  if $.trim($("#attendance_end_time").val()) != "" and ! $.trim($("#attendance_end_time").val()).match(/^\d{1,2}\:\d{2}$/)
    alert "退勤時刻が正しくありません。"
    return

  $.ajax
    url: "/calculate_attendance"
    type: "GET"
    data:
      id: $("#target_id").val() # Attendance.find(params[:id])のため
      pattern: $("#attendance_pattern").val()
      start_time: $("#attendance_start_time").val()
      end_time: $("#attendance_end_time").val()
    dataType: "script"
    success: (data) ->
      return data
    error: (XMLHttpRequest, textStatus, errorThrown) ->
      msg = "--- Error Status ---"
      msg = msg + "<BR>" + "status:" + XMLHttpRequest.status
      msg = msg + "<BR>" + "statusText:" + XMLHttpRequest.statusText
      msg = msg + "<BR>" + "textStatus:" + textStatus
      msg = msg + "<BR>" + "errorThrown:" + errorThrown
      for i of errorThrown
        msg = msg + "<BR>" + "error " + i + ":" + errorThrown[i]
      document.open()
      document.write msg
      document.close()
      return

# データクリア処理
$("#data_clear").click ->
  $('#attendance_pattern').val("");
  $('#attendance_start_time').val("");
  $('#attendance_end_time').val("");

  $( "#attendance_byouketu" ).prop( "checked", false );
  $( "#attendance_kekkin" ).prop( "checked", false );
  $( "#attendance_hankekkin" ).prop( "checked", false );
  $( "#attendance_tikoku" ).prop( "checked", false );
  $( "#attendance_soutai" ).prop( "checked", false );
  $( "#attendance_gaisyutu" ).prop( "checked", false );
  $( "#attendance_tokkyuu" ).prop( "checked", false );
  $( "#attendance_furikyuu" ).prop( "checked", false );
  $( "#attendance_yuukyuu" ).prop( "checked", false );
  $( "#attendance_hankyuu" ).prop( "checked", false );
  $( "#attendance_syuttyou" ).prop( "checked", false );

  $( '#attendance_over_time' ).val("0.00");
  $( '#attendance_holiday_time' ).val("0.00");
  $( '#attendance_midnight_time' ).val("0.00");
  $( '#attendance_break_time' ).val("0.00");
  $( '#attendance_kouzyo_time' ).val("0.00");
  $( '#attendance_work_time' ).val("0.00");

  $( '#attendance_remarks' ).val("");
