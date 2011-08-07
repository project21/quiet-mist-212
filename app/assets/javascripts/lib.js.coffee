window.autocomplete_schools = (jq_auto, callback) ->
  $.get('/courses/school', (data) ->
    jq_auto.autocomplete({
      source: $.map(data, (course) -> {label: course.subject, data: course.id})
    }).bind('autocompleteselect', (ev,ui) -> callback(ui.item.data))
  )
