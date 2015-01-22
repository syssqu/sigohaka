# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# 一覧ページで年月度が変更された際に表示を切り替える
$("select#paper_years").change ->
  $("form").submit();

$("select#user_id").change ->
  $("form").submit();