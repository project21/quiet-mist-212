_.extend Backbone.Model.prototype,
  toJSON : ->
    csrfName = $("meta[name='csrf-param']").attr('content')
    csrfValue = $("meta[name='csrf-token']").attr('content')
    object = {}
    object[csrfName] = csrfValue
    object[@model_name] =
       _.clone(@attributes)
    object

Course = Backbone.Model.extend(
  model_name: 'course'
)

CourseCollection = Backbone.Collection.extend(
  model : Course
  url: '/courses'
)
window.Courses = new CourseCollection

CourseView = Backbone.View.extend(
  tagName:  "tr"
  className:  "course"
  
  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td><span class="subject"><%= subject %></span></td>
    ''')

  render: ->
    $(@el).html(@template(@model.attributes))
    this
)

CourseAppView = Backbone.View.extend({
  el: "#edit-course-profile"

  events:
    'submit #new_course': "save"

  save: (e) ->
    obj = form_to_json(e)['course']
    course = new Courses.model(obj)
    e.currentTarget.reset()
    Courses.add(course)
    course.save {}, error: (model, rsp) ->
      err = "Did not save: \n" +
      (for field, error of jQuery.parseJSON(rsp.responseText)
        field + " " + error
      ).join(".\n")
      alert(err)
      Courses.remove(course)

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Courses.bind('add', this.addOne)
    Courses.bind('remove', this.removeOne)
    Courses.bind('reset', this.addAll)
    Courses.fetch()

  addOne: (course) ->
    view = new CourseView({model: course})
    this.$("#courses-table").append(view.render().el)

  removeOne: (course) ->
    course.view.remove()

  addAll: ->
    Courses.each(this.addOne)
})

$(->
  window.CourseApp = new CourseAppView
)
