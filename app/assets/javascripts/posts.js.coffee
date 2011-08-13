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

  events:
    "mousedown .responsebutton" : "respond"
  
  respond: (e) ->

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
        <br/>
        <span class="response" style="<%= user_id == window.CURRENT_USER_ID ? 'display:none' : '' %>">
          Quick Reply
        <br/>
          <button class="responsebutton" id="reply"> Send </button>
          <input type="text" />
        </span>
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
    'mousedown #my-posts': "my_posts"

  my_posts: (e) ->
    Posts.filter (p) ->
      if p.get('user_id') != window.CURRENT_USER_ID
        Posts.remove(p)
        p.view.remove()

  save: (e) ->
    SearchedBooks.reset()
    $('#posts-table tr.book').remove()

    post_attrs = form_to_json(e)['post']
    delete post_attrs["0"]
    delete post_attrs[0]
    delete post_attrs['post_type']

    # TODO hard coded!!
    post_attrs['course_id'] = 14
    post_attrs['user_id'] = 5

    post = new Posts.model(post_attrs)
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
  $('#post_post_type').change -> $('#general-field').text($(this).find('option:selected').text())
)
