// This is a manifest file that'll be compiled into including all the files listed below.
// // Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// // be included in the compiled file accessible from http://example.com/assets/application.js
// // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// // the compiled file.
// //
//= require "jquery"
//= require "underscore"
//= require "backbone"
//= require "./lib"
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr, settings) {
    xhr.setRequestHeader("Accept", "application/json");
    settings['dataType'] = "json";
    settings['contentType'] = "application/json";
  }
});


// sign-in
$(document).ready(function() {
  //$('#sign-in-form').removeClass('ui-helper-hidden');	
  $('#email-login-button').click(function(){
	if($('#sign-in-form').hasClass("ui-helper-hidden")){
	$('#sign-in-form').removeClass('ui-helper-hidden');	}
	else {$('#sign-in-form').addClass('ui-helper-hidden');  }
  });    
});

// show
$(document).ready(function() {

  $( '#general-field' ).elastic();

  $(".addbook-field").hide();
  $('.addbookbutton').click(function(){
				if (!$(".addbook-field").is(':visible')) 
					$('.addbook-field').show('fast');
				else 
					$('.addbook-field').hide('fast');
	});
	
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

  $('.responsebutton').click(function(e){ {e.preventDefault();   $('#suggest').dialog({
			   autoOpen:false,
			   buttons:{cancel:function(){$(this).dialog("close");},"Yes":function(){alert("school added");$(this).dialog("close");} },
			   width:340,
			   height:150,
			   position:'center'
  });

  $('#suggest').dialog('open');}});

  //$('#status').selectmenu({style:'dropdown', menuWidth:'250',handleWidth:'26'});
});

// registration/ WELCOME PAGE
$(document).ready(function() {
  //call progress bar constructor  
  $("#progress").progressbar({ change: function() {  
    //update amount label when value changes  
    $("#amount").text($("#progress").progressbar("option", "value") + "%");  
  } });  

  //set click handler for next button  
  $(".savebutton").closest('form').submit(function() { 
     var formToSubmit = $(this).serialize();
     $.ajax({
        url: $(this).attr('action'), 
        data: formToSubmit,
        dataType: "JSON",
        type: "POST"
          });
  //look at each panel  
  $(".form-panel").each(function() {  
    //if it's not the first panel enable the back button  
    ($(this).attr("id") != "panel1") ? null : $(".backbutton").removeAttr("disabled");  
   
    //if the panel is visible fade it out  
    ($(this).hasClass("ui-helper-hidden")) ? null : $(this).fadeOut("fast", function() {  
  
      //add hidden class and show the next panel  
      $(this).addClass("ui-helper-hidden").next().fadeIn("fast", function() {  
  
  
        //remove hidden class from new panel  
        $(this).removeClass("ui-helper-hidden");  
  
        //update progress bar  
        $("#progress").progressbar("option", "value", $("#progress").progressbar("option", "value") + 20);  
      });  
      });  
    });  

     return false; 
  });  
  
  $(".backbutton").click(function(e) {  
  
  //stop form submission  
  e.preventDefault();  
  
  //look at each panel  
  $(".form-panel").each(function() {  
  
    //if the panel is visible fade it out  
    ($(this).hasClass("ui-helper-hidden")) ? null : $(this).fadeOut("fast", function() {  
  
      //add hidden class and show the next panel  
      $(this).addClass("ui-helper-hidden").prev().fadeIn("fast", function() {  
  
        //if it's the first panel disable the back button  
          ($(this).attr("id") != "user-form") ? null : $(".backbutton").attr("disabled", "disabled");  
  
      //remove hidden class from new panel  
      $(this).removeClass("ui-helper-hidden");  
  
      //update progress bar  
      $("#progress").progressbar("option", "value", $("#progress").progressbar("option", "value") - 20);  
      });  
    });  
  });  
});  

var scntDiv = $('#p_scents');
        var i = $('#p_scents p').size() + 1;
        
        $('#addScnt').live('click', function() {
                $('<p> <label>Title:</label> <input id="books_title" name="books[title]" size="45" class="round" type="text" /> <a href="#" id="remScnt">Remove</a></p>').appendTo(scntDiv);
                i++;
                return false;
        });   
        $('#remScnt').live('click', function() { 
                if( i > 1 ) {
                        $(this).parents('p').remove();
                        i--;
                }
                return false;
        });
var add_class = $('#add-class-field');
        var i = $('#add-class-field p').size()+ 1 ;
        
        $('#addcf').live('click', function() {
                $('<p> <label>Title:</label> <input id="courses_subject" name="courses[subject]" size="45" class="round" type="text" /> <a href="#" id="remove">Remove</a></p>').appendTo(add_class);
                i++;
                return false;
        });
        $('#remove').live('click', function() { 
                if( i > 1 ) {
                        $(this).parents('p').remove();
                        i--;
                }
                return false;
        });

 $('#school_name').autocomplete({source:[
   {label:"Sierra community College", data:1},
   {label:"American River College", data:1},
   {label:"california state University,Sacramento", data:1},
   {label:"California Maritime Academy, (Vallejo)", data:1},
   {label:"California Polytechnic State University, (San Luis Obispo)", data:1},
   {label:"California State Polytechnic University, Pomona", data:1},
   {label:"California State University, Bakersfield, (Bakersfield)", data:1},
   {label:"California State University, Channel Islands,(Camarillo)", data:1},
   {label:"California State University, Chico, (Chico)", data:1},
   {label:"California State University, Dominguez Hills, (Carson)", data:1},
   {label:"California State University, East Bay, (Hayward)", data:1},
   {label:"California State University, Fresno, (Fresno)", data:1},
   {label:"California State University, Fullerton, (Fullerton)", data:1},
   {label:"California State University, Long Beach, (Long Beach)", data:1},
   {label:"California State University, Los Angeles, (Los Angeles)", data:1},
   {label:"California State University, Monterey Bay, (Seaside)", data:1},
   {label:"California State University, Northridge, (Northridge)", data:1},
   {label:"California State University, Sacramento, (Sacramento)", data:1},
   {label:"California State University, San Bernardino, (San Bernardino)", data:1},
   {label:"California State University, San Marcos, (San Marcos)", data:1},
   {label:"California State University, Stanislaus", data:1},
   {label:"Humboldt State University, (Arcata)", data:1}
 ]}).bind('autocompleteselect', function(ev,ui) {
   $('#school_id').val(ui.item.data)
 }); 

});

