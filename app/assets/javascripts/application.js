// This is a manifest file that'll be compiled into including all the files listed below.
// // Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// // be included in the compiled file accessible from http://example.com/assets/application.js
// // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// // the compiled file.
// //
//= require "jquery"
//= require "underscore"
//= require "backbone"
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript")
  }
});


function form_to_json(e){
  e.preventDefault();
  return $(e.currentTarget).toObject({rails: true});
}


/* a better way to start backbone ?
var App = {
    Views: {},
    Controllers: {},
    init: function() {
        new App.Controllers.Documents();
        Backbone.history.start();
    }
};

$(function() { App.init(); });
*/
