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

OldCourseCollection = Backbone.Collection.extend(
  model : Course
  url: '/courses?active=0'
)
window.OldCourses = new OldCourseCollection

CourseView = Backbone.View.extend(
  tagName:  "tr"
  className:  "course"
  
  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td><span class="subject"><%= name %></span></td>
    ''')

  render: ->
    $(@el).html(@template(@model.attributes))
    this
)

CourseAppView = Backbone.View.extend({
  events:
    'submit #new_course': "save"

  save: (e) ->
    obj = form_to_json(e)['course']
    course = new @collection.model(obj)
    e.currentTarget.reset()
    @collection.add(course)
    course.save {}, error: (model, rsp) =>
      err = "Did not save: \n" +
      (for field, error of jQuery.parseJSON(rsp.responseText)
        field + " " + error
      ).join(".\n")
      alert(err)
      @collection.remove(course)

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    @collection.bind('add', this.addOne)
    @collection.bind('remove', this.removeOne)
    @collection.bind('reset', this.addAll)
    @collection.fetch()

  addOne: (course) ->
    view = new CourseView({model: course})
    this.$(".courses-table").append(view.render().el)

  removeOne: (course) ->
    course.view.remove()

  addAll: ->
    @collection.each(this.addOne)
})

$(->
  window.CourseApp = new CourseAppView(collection : Courses, el: "#edit-course-profile")
  window.OldCourseApp = new CourseAppView(collection : OldCourses, el: "#taken-classes")
)
