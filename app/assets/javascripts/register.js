//= require "jquery"
//= require "jquery-ui-1.8.14.custom.min"
//= require "underscore"
//= require "backbone"
//= require "form2json/form2json"
//= require "lib"
//= require "books"
//= require "courses"
//= require "fileuploader"

// registration/ WELCOME PAGE
$(document).ready(function() {

  $('.file-uploader').each(function(){
      new qq.FileUploader({
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
          element: this,
          action: $(this).closest('form').attr('action'),
          method: 'PUT'
          // additional data to send, name-value pairs
          // params: { }
      });
  })

  //call progress bar constructor  
  $("#progress").progressbar({ change: function() {  
    //update amount label when value changes  
    $("#amount").text($("#progress").progressbar("option", "value") + "%");  
  } });  

  //set click handler for next button  
  $(".savebutton").closest('form').submit(function(e) { 
     e.preventDefault();
     var action = $(e.currentTarget).attr('action');
     if( action !== '#' ) {
       $.ajax({
          url: action,
          data: $(this).serialize(),
          dataType: "JSON",
          type: "POST"
       });
     }


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
          var pvalue = $("#progress").progressbar("option", "value") + 33;
          $("#progress").progressbar("option", "value", pvalue >= 99 ? 100 : pvalue);  
        });
      });  
    });  
  });  
 

 $('.bookfound').addClass('ui-helper-hidden');
  $('.addbookbutton').click(function(){
    if(!$('.addbook-field').val()=="")
     $('.bookfound').removeClass('ui-helper-hidden'); 
  });

$("ul.edit-form li").click(function(){
  
  $('.form-panels').addClass("ui-helper-hidden");
  switch ($(this).attr('id'))
  {
   case "details":
   $('#user-form').removeClass("ui-helper-hidden");
    break;
   case "bookform" :
   $('#books-form').removeClass("ui-helper-hidden");
   break;
   case "current" :
   $('#edit-course-profile').removeClass("ui-helper-hidden");
   break;
   case "taken":
   $('#taken-classes').removeClass("ui-helper-hidden");
   break;

   case "setting":
   $('#setting-form').removeClass("ui-helper-hidden");
   break;
    
  }
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
 
  var school_name = $('#school_name')
  if(school_name.length > 0) {
    $.get('/schools', function(data){
      school_name.autocomplete({
        source: $.map(data, function(school){ 
           return {label: school.name, data: school.id}
         })
      }).bind('autocompleteselect', function(ev,ui) {
        $('#school_id').val(ui.item.data)
     }); 
    })
  }

  var major_name = $('#user_major')
  if(major_name.length > 0) {
    $.get('/majors', function(data){
      major_name.autocomplete({
        source: $.map(data, function(major){ 
           return {label: major.name, data: major.id}
         })
      }).bind('autocompleteselect', function(ev,ui) {
        $('#major_id').val(ui.item.data)
      }); 
    });
  }

  // TODO: delay this for performance concerns
  autocomplete_courses($('#course_name'), function(course_id){ $("#course_id").val(course_id) });
});
