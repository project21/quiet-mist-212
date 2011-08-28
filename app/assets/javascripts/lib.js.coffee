window.autocomplete_courses = (jq_auto, callback) ->
  $.get('/courses/school', (data) ->
    jq_auto.autocomplete({
      source: $.map(data, (course) -> {label: course.name, data: course.id})
    }).bind('autocompleteselect', (ev,ui) -> callback(ui.item.data))
  )

window.fast_click = (jq, fn) -> jq.mousedown(fn).click((e)->e.preventDefault())
