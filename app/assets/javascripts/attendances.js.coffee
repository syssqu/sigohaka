$("select#attendance_nen_gatudo").change ->
  $("form").submit();

$("#calculate").click ->
  if $("#attendance_pattern").val() == "" or $("#attendance_start_time_4i").val() == "" or $("#attendance_start_time_5i").val() == "" or $("#attendance_end_time_4i").val() == "" or $("#attendance_end_time_5i").val() == ""
    alert "勤務パターンと出退勤時間を入力して下さい。"
    return

  $.ajax
    url: "/calculate_attendance"
    type: "GET"
    data:
      id: $("#target_id").val()
      pattern: $("#attendance_pattern").val()
      start_time_hour: $("#attendance_start_time_4i").val()
      start_time_minute: $("#attendance_start_time_5i").val()
      end_time_hour: $("#attendance_end_time_4i").val()
      end_time_minute: $("#attendance_end_time_5i").val()
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

$("#data_clear").click ->
  $('#attendance_pattern').val("");
  $('#attendance_start_time_4i').val("");
  $('#attendance_start_time_5i').val("");
  $('#attendance_end_time_4i').val("");
  $('#attendance_end_time_5i').val("");

  $( "#attendance_byouketu" ).prop( "checked", false );
  $( "#attendance_kekkin" ).prop( "checked", false );
  $( "#attendance_hankekkin" ).prop( "checked", false );
  $( "#attendance_tikoku" ).prop( "checked", false );
  $( "#attendance_soutai" ).prop( "checked", false );
  $( "#attendance_gaisyutu" ).prop( "checked", false );
  $( "#attendance_tokkyuu" ).prop( "checked", false );
  $( "#attendance_furikyuu" ).prop( "checked", false );
  $( "#attendance_yuukyuu" ).prop( "checked", false );
  $( "#attendance_syuttyou" ).prop( "checked", false );

  $( '#attendance_over_time' ).val("0.00");
  $( '#attendance_holiday_time' ).val("0.00");
  $( '#attendance_midnight_time' ).val("0.00");
  $( '#attendance_break_time' ).val("0.00");
  $( '#attendance_kouzyo_time' ).val("0.00");
  $( '#attendance_work_time' ).val("0.00");
