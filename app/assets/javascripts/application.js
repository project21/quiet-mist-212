//= require "jquery"
//= require "jquery-ui-1.8.14.custom.min"
//= require "underscore"
//= require "backbone"
//= require "form2json/form2json"
//= require "jquery.elastic.source"
//= require "lib"
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
   
 /*  $('.bookfound').addClass('ui-helper-hidden');
  $('.addbookbutton').click(function(){
  	if(!$('.addbook-field').val()=="")
  	 $('.bookfound').removeClass('ui-helper-hidden');	
  });*/
  $( '#general-field' ).elastic();
  $('.post-background').hover(function(){
    if ($(".responsebutton").hasClass('ui-helper-hidden'))
      $(".responsebutton").removeClass('ui-helper-hidden');
      else
      $('.responsebutton').addClass("ui-helper-hidden");
  });
  
		
   $('div.side-box span').click(function(){
 	   { 
		      switch( $(this).attr('id')){
			  case "inbox":	
			 $('#inbox-partial').removeClass("ui-helper-hidden");	
			  break;
			  
			  case "request":
			  $('.notification').hide();	
			   $('#request-partial').show();
			    break;		
  }			    }	
  });

$('.group').click(function(e){e.preventDefault();
  //($('.group-form').hasClass('ui-helper-hidden'))? null :
  $('.group-form').removeClass('ui-helper-hidden'); 

});
$('#create').click(function(){
    $('.classmates').dialog({
         autoOpen:false,
         buttons:{cancel:function(){$(this).dialog("close");},"Yes":function(){alert("submit offer to the database");$(this).dialog("close");} },
         width:300,
         height:250,
         position:'center'
  });
  $('.classmates').dialog('open');
});
 //$('.reservebutton').live('click',function(){alert("h");});
//$('.reservebutton').click(function(){alert('d');});
 /*$('.responsebutton').click(function(){ {  $('#suggest').dialog({
			   autoOpen:false,
			   buttons:{cancel:function(){$(this).dialog("close");},"Yes":function(){alert("school added");$(this).dialog("close");} },
			   width:340,
			   height:150,
			   position:'center'
  });

  $('#suggest').dialog('open');}});*/
  $('.reservebutton').click(function(){ { 
    $('.offer').removeClass('ui-helper-hidden');
    $('.offer').dialog({
         autoOpen:false,
         buttons:{cancel:function(){$(this).dialog("close");},"Yes":function(){alert("submit offer to the database");$(this).dialog("close");} },
         width:200,
         height:150,
         position:'center'
  });
  $('.offer').dialog('open');}

});

  // $('#status').selectmenu({style:'dropdown', menuWidth:'250'});
});
