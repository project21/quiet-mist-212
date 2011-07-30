//= require "jquery"
//= require "jquery-ui-1.8.14.custom.min"
//= require "underscore"
//= require "backbone"
//= require "form2json/form2json"
//= require "jquery.elastic.source"
//= require "books"
//= require "posts"

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr, settings) {
    xhr.setRequestHeader("Accept", "application/json");
    settings['dataType'] = "json";
    settings['contentType'] = "application/json";
  }
});


// home show
$(document).ready(function() {
  $(".attach-text-box").hide();
  $('.attach-message').click(function(e){
      {e.preventDefault(); 
                  if (!$(".attach-text-box").is(':visible')) 
                      $('.attach-text-box').show('fast');}
  });

  
  $( '#general-field' ).elastic();

  $('.notification').hide();		
   $('div.side-box span').click(function(e){
 	   {e.preventDefault(); 
		      switch( $(this).attr('id')){
			  case "inbox":
			  $('.notification').hide();	
			 $('#inbox-partial').show();	
			  break;
			  
			  case "request":
			  $('.notification').hide();	
			   $('#request-partial').show();
			    break;		
  }			    }	
  });

  $('.responsebutton').click(function(){ {  $('#suggest').dialog({
			   autoOpen:false,
			   buttons:{cancel:function(){$(this).dialog("close");},"Yes":function(){alert("school added");$(this).dialog("close");} },
			   width:340,
			   height:150,
			   position:'center'
  });

  $('#suggest').dialog('open');}});

  // $('#status').selectmenu({style:'dropdown', menuWidth:'250'});
});
