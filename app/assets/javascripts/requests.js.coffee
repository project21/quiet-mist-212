RequestAppView = Backbone.View.extend({
  el: "body"

  stop_event : (e) -> e.preventDefault()
  events:
    'mousedown #request': "show_book_request"
    'click #request': "stop_event"
    # 'mousedown #inbox': "inbox"

  show_book_request: (e) ->
    communication_content.html(book_request_template).removeClass('ui-helper-hidden')
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
