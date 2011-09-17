Post = Backbone.Model.extend(
  #url: -> if @id then '/posts/' + @id.toStrig() else '/posts/'

  model_name: 'post'
  traverse_to_top: (n, posts) ->
    if reply = @get('reply')
      @traverse_to_top n, posts.concat(reply)
    else
      [n, reply]
  #confirm: -> Posts.confirmpost.get('post_type_id')

  children: ->
    replies = @get('replies') || []
    replies.concat(_.flatten( _.map(replies, (r) -> r.children()) ))
)

PostCollection = Backbone.Collection.extend(
  model : Post
  url: '/posts'
  latest: ->
    if max_post = @max((p) -> p.id)
      $.get(@url + '/latest', {max_id:max_post.id}, (data) ->
        Posts.add(data)
      )


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
  # add border-bottom similar to: <div  class="post-line"></div>

  events:
    "submit form.response" : "respond"
    "hover td" : "respondHover"

  respondHover: (e) ->
    $(e.currentTarget).find('form').toggleClass('ui-helper-hidden')
  
  respond: (e) ->
    e.preventDefault()
    reply = this.$(e.currentTarget).find('input').val()
    #TODO: validate not empty
    post = Posts.create(user: window.CURRENT_USER, created_at: new Date, course_id: @model.get('course_id'), content: reply, reply_id: @model.id, reply: @model)
    e.currentTarget.reset()

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''

<td class="num_parents_<%= num_parents %> <%= row_classes %>">
    
  <span class="post-course"><%= CURRENT_USER.courses[course_id] %><span><br/>
  <span class="post-type"></span>
  <span class="inline_table"> <img src="<%= image_url %>"/></span>
  <span class="inline_tables"><a href='/home/profile/<%= user_id %>' id="post-user"><%=firstname %> <%=lastname%></a><br/><span class="post-content"><%= content %></span></span><br/>
<!--    <span class="post-content"> <%= content %></span><br/>-->
  <time class="post-sent" datetime="<%= created_at %>"><%= created_at %></time>
  <span class="post-response"></span>

  <br/>

  <form class="response ui-helper-hidden" style="<%= user_id == window.CURRENT_USER.id ? 'display:none' : '' %>">
    <input type="text"   name="post[content]" size="35" >
    <input type="submit"  value="reply" id="responsebutton">
  </form>
</td>

    ''')
       # <button> <%= confirm %> </button>

  render: ->
    attrs = _.clone(@model.attributes)
    attrs.num_parents = @options.num_parents
    attrs.row_classes = @options.row_classes
    user = @model.get('user')
    attrs.image_url = user?.image_url or if user?.photo then user.photo.url else '/assets/main.png'
    attrs.firstname = @model.get('user')?.firstname || 'first'
    attrs.lastname = @model.get('user')?.lastname || 'last'
    $(@el).html(@template(attrs))
    this
)


PostAppView = Backbone.View.extend({
  el: "body"

  stop_event : (e) -> e.preventDefault()

  events:
    'submit #new_post': "save"
    'mousedown #my-posts':  "my_posts"
    'mousedown #all-posts': "all_posts"
    'click #my-posts':  "stop_event"
    'click #all-posts': "stop_event"

  all_posts: (e) ->
    for p in Posts.models
      if !p.view
        view = new PostView({model: post})
        posts_table_body.prepend(view.render().el)
      else
        $(p.view.el).show()
        # posts_table_body.prepend(p.view.render().el)
    show_posts()

  my_posts: (e) ->
    # this could be more efficient
    Posts.each (p) ->
      check_others = p.children()

      unless (p.get('user_id') == window.CURRENT_USER.id) || _(check_others).any( (other) -> other.get('user_id') == window.CURRENT_USER.id )
        $(p.view.el).hide()
    show_posts()

  save: (e) ->
    show_posts()

    post_attrs = form_to_json(e)['post']
    delete post_attrs['post_type']

    # TODO: supposed to default to all?
    # The whole multiple course id thing is pretty hacky
    if !post_attrs[0]
      alert("Please select a course for this post.")
      return

    post = Posts.create(user: window.CURRENT_USER, created_at: new Date, content: post_attrs.content, course_ids: post_attrs.slice(), course_id: post_attrs.pop())
    #for course_id in post_attrs
      #post = new Posts.model(user: window.CURRENT_USER, created_at: new Date, content: post_attrs.content, course_id: course_id)
      #Posts.add(post)
    e.currentTarget.reset()

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Posts.bind('add', this.addOne)
    Posts.bind('reset', this.addAll)
    Posts.fetch()

  addOne: (post, num_parents, row_classes) ->
    post.set('user_id': window.CURRENT_USER.id) if !post.get('user_id')

    if typeof num_parents == "number"
      view = new PostView({model: post, num_parents: num_parents, row_classes: row_classes})
      reply_models = for reply in (post.get('replies') || []).reverse()
        _(new Posts.model(reply)).tap (reply_model) =>
          @addOne(reply_model, num_parents + 1, 'post-reply')
      post.set(replies: reply_models)
      posts_table_body.prepend(view.render().el)
    else
      reply = post.get('reply')
      if reply?
        [num_parents, parents] = reply.traverse_to_top 0, []
        view = new PostView({model: post, num_parents: num_parents + 1, row_classes: 'post-reply'})
        $(reply.view.el).after(view.render().el)
        delete post.attributes['reply']
      else
        view = new PostView({model: post, num_parents: 0, row_classes: 'post-reply'})
        posts_table_body.prepend(view.render().el)

  addAll: ->
    Posts.each((p) =>
      this.addOne(p, 0))
})

window.posts_container = null
window.posts_table_body = null
window.show_posts = (e) ->
  communication_content.addClass('ui-helper-hidden')
  searched_books_table.addClass('ui-helper-hidden')
  posts_container.removeClass('ui-helper-hidden')


$(->
  window.posts_container = $('#posts-container')
  window.posts_table_body = posts_container.find('tbody')
  window.PostApp = new PostAppView
  $('#post_post_type').change -> $('#general-field').text($(this).find('option:selected').text())
  setInterval("Posts.latest()", 3000)
)
