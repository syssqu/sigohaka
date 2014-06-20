$("select#attendance_nen_gatudo").change ->
  $("form").submit();

$("#calculate").click ->
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
    error: (data) ->
      alert "errror"
      return