Post = Backbone.Model.extend(
  model_name: 'post'
  #confirm: -> Posts.confirmpost.get('post_type_id')
)

PostCollection = Backbone.Collection.extend(
  model : Post
  url: '/posts'

  #confirm: (post_type_id) ->
    #switch post_type_id
      #when 1 # help
        #"I can help"
      #when 2 # study guide
        #"I have it"
      #when 3 # need study budy
        #"I'm down"
      #else # other
        #""
)

window.Posts = new PostCollection

PostView = Backbone.View.extend(
  tagName:  "tr"
  className:  "post"
  
  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td>
        <span class="post-user"><%= user_id %><span>
        <span class="post-course"><%= course_id %><span>
        <span class="post-type"></span>
        <span class="post-content"><%= content %></span>
        <span class="post-response"></span>

        <button class="responsebutton" id="reply"> Reply </button>
      </td>
    ''')
       # <button> <%= confirm %> </button>

  render: ->
    $(@el).html(@template(@model.attributes))
    this
)

PostAppView = Backbone.View.extend({
  el: "body"

  events:
    'submit #new_post': "save"

  save: (e) ->
    SearchedBooks.reset()
    # TODO: 
    #$('#posts-table tr.book').remove()

    obj = form_to_json(e)['post']
    obj['user_id'] = 1
    obj['course_id'] = 1
    post = new Posts.model(obj)
    Posts.add(post)
    post.save()
    e.currentTarget.reset()

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Posts.bind('add', this.addOne)
    Posts.bind('reset', this.addAll)
    Posts.fetch()

  addOne: (post) ->
    view = new PostView({model: post})
    # TODO: add class if it is reserved
    this.$("#posts-table").append(view.render().el)

  addAll: ->
    Posts.each(this.addOne)
})

$(->
  window.PostApp = new PostAppView
  $('#status').change -> $('#general-field').text($(this).find('option:selected').text())
)
