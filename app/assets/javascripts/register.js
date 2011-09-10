//= require "jquery"
//= require "jquery-ui-1.8.14.custom.min"
//= require "underscore"
//= require "backbone"
//= require "form2json/form2json"
//= require "lib"
//= require "books"
//= require "courses"
//= require jquery_ujs
//= require jquery.remotipart

// registration/ WELCOME PAGE
$(document).ready(function() {

  //call progress bar constructor  
  $("#progress").progressbar({ change: function() {  
    //update amount label when value changes  
    $("#amount").text($("#progress").progressbar("option", "value") + "%");  
  } });  

  //set click handler for next button  
  $(".savebutton").closest('form').submit(function(e) { 
     if( !$(this).attr('data-remote') ) {
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
     }


    school_exists = false;
    //look at each panel  
    $(".form-panel").each(function() {
      //if it's not the first panel enable the back button  
      var that = $(this);
      (that.attr("id") != "panel1") ? null : $(".backbutton").removeAttr("disabled");  

      // on /home/welcome delayed until now when a school should exist
      if (!school_exists){
        autocomplete_courses($('#course_name'), function(course_id){ $("#course_id").val(course_id) });
        school_exists = true;
      }
     
      //if the panel is visible fade it out  
      (that.hasClass("ui-helper-hidden")) ? null : that.fadeOut("fast", function() {  
    
        //add hidden class and show the next panel  
        $(this).addClass("ui-helper-hidden").next().fadeIn("fast", function() {  
    
          //remove hidden class from new panel  
          $(this).removeClass("ui-helper-hidden");  
          // this is a hack to remove the display:block from the fadeIn
          $(this).attr('style', '')
    
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

  $("ul.edit-form li").click(function(e){
    e.preventDefault();
    $('.form-panel').addClass("ui-helper-hidden");

    var panel = null;
    switch ($(this).attr('id'))
    {
       case "details":
         panel = '#user-form';
         break;
       case "bookform" :
         panel = '#books-form';
         break;
       case "current" :
         // on /home/welcome delayed until now when a school should exist
         autocomplete_courses($('#course_name'), function(course_id){ $("#course_id").val(course_id) });
         panel = '#edit-course-profile';
         break;
       case "taken":
         panel = '#taken-classes';
         break;
       case "setting":
         panel = '#setting-form';
         break;
    }
    if(panel) $(panel).removeClass("ui-helper-hidden");
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
});
