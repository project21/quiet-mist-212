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
  # add border-bottom similar to: <div  class="post-line"></div>

  events:
    "submit form.response" : "respond"
    "hover td" : "respondHover"

  respondHover: (e) ->
    $(e.currentTarget).find('form').toggleClass('ui-helper-hidden')
  
  respond: (e) ->
    reply = this.$(e.currentTarget).find('input').val()
    #TODO: validate not empty
    post = new Posts.model(user: window.CURRENT_USER, created_at: new Date, course_id: @model.get('course_id'), content: reply, reply_id: @model.id)
    Posts.add(post)
    post.save()
    e.preventDefault()
    e.currentTarget.reset()

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
     <td>
       <span class="post-course"><%= course_id %><span><br/>
       <span class="post-type"></span>
       <span class="inline_table"> <img src="<%= user.image_url || '/assets/rails.png' %>"/></span>
       <span class="inline_table"><a href="#" id="post-user" ><%= user.firstname%>&nbsp;<%=user.lastname %></a></span><br/>
      <span class="inline_table"> <%= content %></span><br/>
       <time class="post-sent" datetime="<%= created_at %>"><%= created_at %></time>
       <span class="post-response"></span>

        <br/>
        <form class="response ui-helper-hidden" style="<%= user_id == window.CURRENT_USER.id ? 'display:none' : '' %>">
          <input type="text"   name="post[content] size="35" >
          <input type="submit"  value="reply" class="responsebutton" >
        </form>
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
      if p.get('user_id') != window.CURRENT_USER.id
        Posts.remove(p)
        p.view.remove()

  save: (e) ->
    SearchedBooks.reset()
    $('#posts-table tr.book').remove()

    post_attrs = form_to_json(e)['post']
    delete post_attrs['post_type']

    # TODO: supposed to default to all?
    # The whole multiple course id thing is pretty hacky
    if !post_attrs[0]
      alert("no course checked off")
      return

    post = new Posts.model(user: window.CURRENT_USER, created_at: new Date, content: post_attrs.content, course_ids: post_attrs.slice(), course_id: post_attrs.pop())
    Posts.add(post)
    post.save()
    for course_id in post_attrs
      post = new Posts.model(user: window.CURRENT_USER, created_at: new Date, content: post_attrs.content, course_id: course_id)
      Posts.add(post)
    e.currentTarget.reset()

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Posts.bind('add', this.addOne)
    Posts.bind('reset', this.addAll)
    Posts.fetch()

  addOne: (post) ->
    post.set('user_id': window.CURRENT_USER.id) if !post.get('user_id')
    view = new PostView({model: post})
    this.$("#posts-table").prepend(view.render().el)
    #console.log(post)
    #for reply in post.get('replies')
      #@addOne(new Posts.model(reply))

  addAll: ->
    Posts.each(this.addOne)
})

$(->
  window.PostApp = new PostAppView
  $('#post_post_type').change -> $('#general-field').text($(this).find('option:selected').text())
)
