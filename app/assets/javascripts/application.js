// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });


/** 
 * 指定されたIDのセレクトボックスにおいて、インデックスではなくて値によってオプションを選択する
 * @param formSelectId 対象のセレクトボックスのID
 *        itemValue 選択する値
 * @return void
 */
function selectedChange(formSelectId, itemValue, is_blank){

    var target = is_blank ? "" : ("0"+itemValue).slice(-2);
    
    var objSelect = document.getElementById(formSelectId);
    var m = objSelect.length;
    var i = 0;
    
    for(i=0; m>i; i++){
        if(objSelect.options[i].value == target){
            objSelect.options[i].selected = true;
            break;
        }
    }
}
