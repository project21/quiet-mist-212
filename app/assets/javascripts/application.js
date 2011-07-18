// This is a manifest file that'll be compiled into including all the files listed below.
// // Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// // be included in the compiled file accessible from http://example.com/assets/application.js
// // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// // the compiled file.
// //
//= require "jquery"
//= require "underscore"
//= require "backbone"
//= require "lib"
//= require_tree .

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript")
  }
});

$(document).ready(function() {
  /*
	$('#status').selectmenu({style:'dropdown', menuWidth:'250',handleWidth:'26'});
    */
	
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
			   });$('#suggest').dialog('open');}});




//WELCOME PAGE

//call progress bar constructor  
  $("#progress").progressbar({ change: function() {  
    //update amount label when value changes  
    $("#amount").text($("#progress").progressbar("option", "value") + "%");  
  } });  
  //set click handler for next button  
  $(".savebutton").click(function() {  
  	alert("helo");
   var formToSubmit = $(this).serialize();
    $.ajax({
        url: $(this).attr('action'), 
        data: formToSubmit,
        dataType: "JSON" 
          });
      // return false; 
  //look at each panel  
  $(".form-panel").each(function() {  
    //if it's not the first panel enable the back button  
    ($(this).attr("id") != "panel1") ? null : $(".backbutton").attr("disabled", "");  
   
    //if the panel is visible fade it out  
    ($(this).hasClass("ui-helper-hidden")) ? null : $(this).fadeOut("fast", function() {  
  
      //add hidden class and show the next panel  
      $(this).addClass("ui-helper-hidden").next().fadeIn("fast", function() {  
  
        //if it's the last panel disable the next button  
            ($(this).attr("id") != "taken-classes") ? null : $(".savebutton").attr("disabled", "");  
  
        //remove hidden class from new panel  
        $(this).removeClass("ui-helper-hidden");  
  
        //update progress bar  
        $("#progress").progressbar("option", "value", $("#progress").progressbar("option", "value") + 20);  
      });  
      });  
    });  
  });  
  
  $(".backbutton").click(function(e) {  
  
  //stop form submission  
  e.preventDefault();  
  
  //look at each panel  
  $(".form-panel").each(function() {  
  
    //if it's not the last panel enable the next button  
    ($(this).attr("id") != "taken-classes") ? null : $(".savebutton").attr("disabled", "");  
  
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

 $('#school').autocomplete({source:["Sierra community College","American River College","california state University,Sacramento",
"California Maritime Academy, (Vallejo)",
"California Polytechnic State University, (San Luis Obispo)",
"California State Polytechnic University, Pomona",
"California State University, Bakersfield, (Bakersfield)",
"California State University, Channel Islands,(Camarillo)",
"California State University, Chico, (Chico)",
"California State University, Dominguez Hills, (Carson)",
"California State University, East Bay, (Hayward)",
"California State University, Fresno, (Fresno)",
"California State University, Fullerton, (Fullerton)",
"California State University, Long Beach, (Long Beach)",
"California State University, Los Angeles, (Los Angeles)",
"California State University, Monterey Bay, (Seaside)",
"California State University, Northridge, (Northridge)",
"California State University, Sacramento, (Sacramento)",
"California State University, San Bernardino, (San Bernardino)",
"California State University, San Marcos, (San Marcos)",
"California State University, Stanislaus, (Turlock)",
"Humboldt State University, (Arcata)"]}); 

});

