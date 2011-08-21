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
    form = $(e.currentTarget).parent()
    reply = form.find('input').val()
    #TODO: validate not empty
    post = new Posts.model(created_at: new Date, course_id: @model.get('course_id'), content: reply, reply_id: @model.id)
    Posts.add(post)
    post.save()
    form[0].reset()
    e.preventDefault()

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      
<!--TODO:the post is duplicated ,dispalys two post evertime-->
<!--TODO:also the newer ones should display up top-->
<!--TODO:validate if somebody dont enter anything in post field-->
   <td>   
<div class="post-background">
<div class="post-course"><%= course_id %></div>
<div id="post-pic" class="inline_table"> <img src="/assets/images/rails.png" alt="rails"/></div> 
<div> <a href="#" id="post-user" class="inline_table"><%= user.firstname%>&nbsp;<%=user.lastname %></a> </div>  
<div id="post-content" class="inline_table"><%= content %></div>
<div class="clear"></div>
<span class="post-sent"><%= created_at %></span>
        <span class="post-response"></span>
        <br/> 
        <form class="response" style="<%= user_id == window.CURRENT_USER_ID ? 'display:none' : '' %>">
          Quick reply
<input type="text" name="post[content] class="reply-field" />
  <button class="responsebutton" > Send </button>
         
        </form>
       
        </div>
       </td>
      <div  class="post-line"></div>
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
    delete post_attrs['post_type']

    # TODO: supposed to default to all?
    # The whole multiple course id thing is pretty hacky
    if !post_attrs[0]
      alert("no course checked off")
      return

    post = new Posts.model(created_at: new Date, content: post_attrs.content, course_ids: post_attrs.slice(), course_id: post_attrs.pop())
    Posts.add(post)
    post.save()
    for course_id in post_attrs
      post = new Posts.model(created_at: new Date, content: post_attrs.content, course_id: course_id)
      Posts.add(post)
    e.currentTarget.reset()

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Posts.bind('add', this.addOne)
    Posts.bind('reset', this.addAll)
    Posts.fetch()

  addOne: (post) ->
    post.set('user_id': window.CURRENT_USER_ID) if !post.get('user_id')
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
