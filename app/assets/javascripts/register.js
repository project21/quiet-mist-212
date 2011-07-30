//= require "jquery"
//= require "jquery-ui-1.8.14.custom.min"

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
                $('<p> <label>Book:</label> <input id="books_title" name="books[title]" size="45" class="round" type="text" /> <a href="#" id="remScnt">Remove</a></p>').appendTo(scntDiv);
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
                $('<p> <label>class</label> <input id="courses_subject" name="courses[subject]" size="45" class="round" type="text" /> <a href="#" id="remove">Remove</a></p>').appendTo(add_class);
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


var add_class_tk = $('#add-class-taken');
        var i = $('#add-class-taken p').size()+ 1 ;
        
        $('#addct').live('click', function() {
                $('<p> <label>class</label> <input id="courses_subject" name="courses[subject]" size="45" class="round" type="text" /> <a href="#" id="remove_ct">Remove</a></p>').appendTo(add_class_tk);
                i++;
                return false;
        });
        $('#remove_ct').live('click', function() { 
                if( i > 1 ) {
                        $(this).parents('p').remove();
                        i--;
                }
                return false;
        });

 
 $('#major').autocomplete({source: ["undeclared",
    "Architectural Design","Art and Design","Administration of justice",
     "Atmosphere and Energy","Aeronautics and Astronautics",
     "Administration of justice","Computer science","African American Studies",
     "American Cultures","Chemical Engineering","Mechanical Engineering","Envronmental Engineering",
     "Political science"] });

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

