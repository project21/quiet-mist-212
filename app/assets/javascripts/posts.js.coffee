Post = Backbone.Model.extend(
  #url: -> if @id then '/posts/' + @id.toStrig() else '/posts/'

  model_name: 'post'

  image_url: ->
    if user = @get('user')
      user.photo?.url or user.image_url

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
        for d in data
          Posts.add(d) unless Posts.get(d.id)
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

make_post = (e, model, cb) ->
  f = $(e.currentTarget)
  # we are using remotipart which uses rails remote form which defines these events
  f.bind 'ajax:beforeSend', (evt, xhr, settings) =>
    if model
      f.addClass('ui-helper-hidden').siblings('button.reply').removeClass('ui-helper-hidden')
    xhr.setRequestHeader("Accept", "application/json")
    return

  f.bind 'ajax:success', (evt, data, status, xhr) =>
    data.user = window.CURRENT_USER
    data.reply = model
    try
      Posts.add(data)
    catch error
    return

  f.bind 'ajax:complete', (evt, xhr, status) =>
    e.currentTarget.reset()
    cb() if cb
    return

  f.bind 'ajax:error', (evt, xhr, status, error) ->
    alert("Sorry, your post was not saved. Maybe you can try again.")
    return

PostView = Backbone.View.extend(
  tagName:  "tr"
  className:  "post"
 
  events:
    "submit form.response" :"respond"
    "mousedown  td ":"respondHover"
    "click td" :"elastic"
 
    
  elastic: (e) -> $(e.currentTarget).find('.reply-field' ).elastic()

  respondHover: (e) ->
    $(e.currentTarget).find('form.response').removeClass('ui-helper-hidden')
    $(e.currentTarget).find('button.reply').addClass('ui-helper-hidden')
  
  respond: (e) -> make_post(e, @model)

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
<td class="num_parents_<%= num_parents %> <%= row_classes %>">
  <span class="post-course"><b><%= CURRENT_USER.courses[course_id] %></b><span>
 <img src="/assets/arrow.png"><span class="post-type"><b><%=post_type%></b></span>
  <br/>
 
  <span class="inline_table"> <img src="<%= image_url %>"/></span>
  <span class="inline_tables"><a href="/home/user_profile/<%= user_id %>" id="post-user"><%=firstname %> <%=lastname%></a><br/><span class="post-content"><%= content %><br/>
     <a class="post-attachment" href="<%= attachment_url %>" > <%= attachment %>
       </a>
    </span></span><br/>
   <div class="clear"></div> 

  <time class="post-sent" datetime="<%= created_at %>"><%= timeago(created_at) %></time>
 
  <span class="post-response"></span>

  <div style="<%= user_id == window.CURRENT_USER.id ? 'display:none' : '' %>">
    <span class="reply-line"  style="<%= user_id == window.CURRENT_USER.id ? 'display:none' : '' %>"></span><br/>
    <button class="reply responsebutton" type="button">Reply</button>

    <form data-remote="true" data-type="json" class="response ui-helper-hidden" action="/posts" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
      <input type="hidden" name="authenticity_token" value="<%= authenticity_token %>"/>
      <input type="hidden" name="post[reply_id]" value="<%= id %>"/>
      <input type="hidden" name="post[course_id]" value="<%= course_id %>"/>
      <textarea name="post[content]" class="reply-field" rows="1" cols="50"/><br/>
      <input type="submit" value="send" name="responsebutton" />
      <input type="file" name="post[attachment]" />
    </form>
  </div>
</td>
    ''')

  render: ->
    attrs = _.clone(@model.attributes)
    attrs.num_parents = @options.num_parents
    attrs.row_classes = @options.row_classes
    attrs.image_url   = @model.image_url() or '/assets/main.png'
    attrs.firstname   = @model.get('user')?.firstname || 'first'
    attrs.lastname    = @model.get('user')?.lastname || 'last'
    attrs.attachment_url  = @model.get('attachment')?.attachment?.url
    attrs.attachment = _.last((attrs.attachment_url || "").split('/'))
    csrfValue = $("meta[name='csrf-token']").attr('content')
    attrs.authenticity_token = csrfValue
    attrs.timeago = $.timeago
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

    if !post_attrs[0]
      alert("Please select a course for this post.")
      return false

    make_post e, null, -> $(".collection_check_boxes").removeClass("active-state")
    $(e.currentTarget).find('input[type=file]').addClass('ui-helper-hidden')

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Posts.bind('add', this.addOne)
    Posts.bind('reset', this.addAll)
    Posts.fetch()

  appendViewToTable: (view) ->
    e = view.render().el
    posts_table_body.prepend(e)
    $(e).effect('highlight', 2000) unless @noHighlight

  addOne: (post, num_parents, row_classes) ->
    post.set('user_id': window.CURRENT_USER.id) if !post.get('user_id')

    if typeof num_parents == "number"
      view = new PostView({model: post, num_parents: num_parents, row_classes: row_classes})
      reply_models = for reply in (post.get('replies') || []).reverse()
        _(new Posts.model(reply)).tap (reply_model) =>
          @addOne(reply_model, num_parents + 1, 'post-reply')
      post.set(replies: reply_models)
      @appendViewToTable view
    else
      reply = post.get('reply')
      if reply
        [num_parents, parents] = reply.traverse_to_top 0, []
        view = new PostView({model: post, num_parents: num_parents + 1, row_classes: 'post-reply'})
        $(reply.view.el).after(view.render().el)
        delete post.attributes['reply']
      else
        view = new PostView({model: post, num_parents: 0})
        @appendViewToTable view

  withoutHighlight: (f) ->
    @noHighlight = true
    f()
    @noHighlight = false

  addAll: ->
    @withoutHighlight =>
      Posts.each((p) =>
        this.addOne(p, 0))
})

window.posts_container = null
window.posts_table_body = null

window.hide_main_posts = ->
  posts_container.addClass('ui-helper-hidden')

window.show_posts = ->
  hide_main_requests()
  hide_main_books()
  posts_container.removeClass('ui-helper-hidden')


for_collection_checkbox = (jq) -> $_('#' + jq.attr('for'))

$(->
  $(".collection_check_boxes").click (e) ->
    e.preventDefault()
    cbox = for_collection_checkbox($(this).toggleClass("active-state"))
    if cbox.checked
      cbox.removeAttr('checked', 'checked')
    else
      cbox.attr('checked', 'checked')

  window.posts_container = $('#posts-container')
  window.posts_table_body = posts_container.find('tbody')
  window.PostApp = new PostAppView
  # $('#post_post_type').change ->
  #  $('#general-field').val($(this).find('option:selected').text())
  setInterval("Posts.latest()", 5000)
  $('#material-field').val("")
)
