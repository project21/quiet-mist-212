//= require "jquery"
//= require "jquery-ui-1.8.14.custom"

$(document).ready(function() {
  //$('#sign-in-form').removeClass('ui-helper-hidden');	
  $('#email-login-button').click(function(){
	if($('#sign-in-form').hasClass("ui-helper-hidden")){
	$('#sign-in-form').removeClass('ui-helper-hidden');	}
	else {$('#sign-in-form').addClass('ui-helper-hidden');  }
  });    
});
