window.autocomplete_courses = (jq_auto, callback) ->
  $.get('/courses/school', (data) ->
    jq_auto.autocomplete({
      source: $.map(data, (course) -> {label: course.name, data: course.id})
    }).bind('autocompleteselect', (ev,ui) -> callback(ui.item.data))
  )

window.fast_click = (jq, fn) -> jq.mousedown(fn).click((e)->e.preventDefault())

# same as jQuery $
# but throw an exception if no elements are found
window.$_ = (arg1, arg2) ->
  selected = jQuery(arg1, arg2)
  return selected if selected.length

  msg = if arg2
    "expected '$('" + arg1 + "','" + arg2 + "') to match something"
  else
    "expected '" + arg1 + "' to match something"
  if window.location.href.match(/localhost/)
    console.log msg
  throw msg
