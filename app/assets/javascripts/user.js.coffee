(($) ->
  simpleOptions = (arr) ->
    $options = @find("option")
    selected = @val()
    diff = arr.length - $options.length
    if diff < 0
      $options.slice(diff).remove()
    else if diff > 0
      fragment = document.createDocumentFragment()
      i = diff

      while i
        fragment.appendChild document.createElement("option")
        --i
      @append fragment
    some = arr.some((v) ->
      !!v.selected
    )
    @find("option").each (i, v) ->
      v.value = arr[i].value
      v.text = arr[i].text
      v.selected = (if some then !!arr[i].selected else "" + arr[i].value is selected)
      v.disabled = !!arr[i].disabled
      for k of v.dataset
        continue
      for k of arr[i]
        continue
      return

    @change()  if @val() isnt selected
    this

  $.fn.simpleOptions = simpleOptions
  return
) jQuery

calculateAge = (year, month, day) ->

  if year is 0 or month is 0 or day is 0
    return

  today = new Date()
  today = today.getFullYear() * 10000 + today.getMonth() * 100 + 100 + today.getDate()
  birthday = parseInt( year.toString(10) + ("0" + month ).slice(-2) + ("0" + day ).slice(-2))
  Math.floor (today - birthday) / 10000

date_select_update_day = ->
  day = [ text:"", value:""]
  day_max = 31

  year = Number($("#user_birth_date_1i option:selected").val())
  month = Number($("#user_birth_date_2i option:selected").val())

  day_max = 31
  if month is 2
    day_max = 28
    day_max = 29  if year % 400 is 0 or (year % 4 is 0 and year % 100 isnt 0)
  else day_max = 30  if month is 4 or month is 6 or month is 9 or month is 11

  i = 1
  while i <= day_max
    day.push
      text: i.toString(10)
      value: i.toString(10)
    i++

  $("#user_birth_date_3i").simpleOptions day

  selected_day = Number($("#user_birth_date_3i option:selected").val())
  $("#user_age").val(calculateAge(year, month, selected_day))

$("select#user_birth_date_1i").change ->
  date_select_update_day()

$("select#user_birth_date_2i").change ->
  date_select_update_day()

$("select#user_birth_date_3i").change ->
  year = Number($("#user_birth_date_1i option:selected").val())
  month = Number($("#user_birth_date_2i option:selected").val())
  selected_day = Number($("#user_birth_date_3i option:selected").val())
  $("#user_age").val(calculateAge(year, month, selected_day))