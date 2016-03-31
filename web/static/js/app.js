// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import jinput from "./json-field-input"


$(function () {
  $('.minimal-check').iCheck({
    checkboxClass: 'icheckbox_minimal',
    radioClass: 'iradio_minimal',
    increaseArea: '20%'
  });

  $('.chosen-select').chosen({allow_single_deselect: true, width: "50%"});
  $('.scroll').slimScroll({
    height: '800px'
  });

  $('.json-input').on('click','.json-input-add', function(e){
    var target = $(e.target);
    var box = target.attr("data-target");
    var kname = target.attr("data-kname");
    var vname = target.attr("vname");
    $(jinput(kname,vname)).appendTo(box);
  });

  $('.json-input').on('click','.json-input-remove', function(e){
    var target = $(e.target).parent().parent();
    $(target).remove();
  });
});
