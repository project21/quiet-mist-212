RequestAppView = Backbone.View.extend({
  el: "body"

  stop_event : (e) -> e.preventDefault()
  events:
    'mousedown #request': "show_book_request"
    'click #request': "stop_event"
    'mousedown #inbox': "show_inbox"
    'click #inbox': "stop_event"

  show_book_request: (e) ->
    communication_content.html(book_request_template).removeClass('ui-helper-hidden')
    show_book_requests()

  show_inbox: (e) ->
    communication_content.html(inbox_template).removeClass('ui-helper-hidden')
    show_book_requests()
})

window.show_book_requests = (e) ->
  requests_table.addClass('ui-helper-hidden')
  posts_container.addClass('ui-helper-hidden')
  searched_books_table.removeClass('ui-helper-hidden')

window.communication_content = null
$(->
  window.RequestApp = new RequestAppView
  window.communication_content = $('#communication-content')
)

window.book_request_template = '''
    <h3>Request &Response</h3>
    <div class="inbox-divider"></div>
      <div class="inbox-content">

      <div>
        <span>john</span><br/>
        <span>wants to reserve</span>&nbsp;
        <span>physics book</span> &nbsp;for <span>price</span>

        <div>
          <span class="denybutton"><a href='/books/new'/>Decline</a></span>
          <span class="acceptbutton"><a href='/books/new'>Accept</a></span>
        </div>
      </div>
      <div class="container-dotted"></div>
    </div>
'''

window.inbox_template = '''
<h3 class="message-title">Inbox </h3>
<div class="inbox-wrapper center">
  <div style="padding:20px;">
    <div style="color:#808080;font-size:16px;font-weight:bold;text-align:center;">You have no messages</div>
  </div>
</div>
'''
