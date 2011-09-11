_.extend Backbone.Model.prototype,
  toJSON : ->
    csrfName = $("meta[name='csrf-param']").attr('content')
    csrfValue = $("meta[name='csrf-token']").attr('content')
    object = {}
    object[csrfName] = csrfValue
    attrs = _.clone(@attributes)
    delete attrs.reserver_id
    object[@model_name] = attrs
    object

Book = Backbone.Model.extend(
  model_name: 'book_ownership' # used for the url
  reserve: -> $.post('book_ownerships/' + @id.toString() + '/reserve?amount=0', @toJSON())
  requested: -> get('reserver_id')
)

BookOwnershipCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships'
)
BookReservedCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships/reserved'
)
BookSearchCollection = Backbone.Collection.extend(
  model : Book
  transfer_to: (collection, book, options) ->
    this.remove(book)
    book.unset('reserver_id', silent: true)
    collection.add(book)
    if options && options['reserve']
      book.reserve()
    else
      book.save()
)

window.OwnedBooks = new BookOwnershipCollection
window.UndoRemovedBooks = new BookOwnershipCollection
window.SearchedBooks = new BookSearchCollection
window.ReservedBooks = new BookReservedCollection

OwnedBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"
  
  events:
    # not used yet
    'mousedown .remove': "remove_book"

  remove_book: (e) ->
    e.preventDefault()
    $(@el).remove()
    OwnedBooks.remove(@model)

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td class='title'><%= title %></td>
      <td class='edition'><%= edition %></td>
      <td class='author'><%= author %></td>
      <td> <% if(reserver_id) {%><span class='reserved'>reserved</span><%}%> </td>  
    ''')

  render: ->
    $(@el).html(@template(@model.attributes))
    this
)

ReservedBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"
  
  events:
    # not used yet
    'click .remove': "remove_book"

  remove_book: (e) ->
    e.preventDefault()
    $(@el).remove()
    OwnedBooks.remove(@model)

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td class='title'><a href="#"> <%= title %></a></td>
      <td class='edition'><%= edition %></td>
      <td class='author'><%= author %></td>
      <td><span class='reserved'>Reserved</span></td>
    ''')

  render: ->
    $(@el).html(@template(@model.attributes))
    this
)

SearchedBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"
  
  events:
    'click td': "choose_book"

  choose_book: (e) ->
    e.preventDefault()
    SearchedBooks.reset()
    if @options['reserve']
      view = new ReserveClassmateBookView(model: @model)
      view.render().el.dialog()
    else
      add_course_name.dialog()
      autocomplete_courses $('#add-course-name'), (course_id) =>
        @model.set(course_id: course_id)
        SearchedBooks.transfer_to(OwnedBooks, @model)
        add_course_name.dialog('close')
        show_posts()

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td class='title'><a href="#"> <%= title %></a></td>
      <td class='edition'><%= edition %></td>
      <td class='author'><%= author %></td>

    ''')

  render: ->
    # TODO cutoff title after x chars
    # TODO cutoff authors after 1 author
    $(@el).html(@template(@model.attributes))
    this
)


reserve_book_template = '''
<div>
  <span class="reserve-book">Reserve from your classmates</span>
  <p class="finding-owners">
    Looking for classmates with this book ...
  </p>
  <table class="found-owners">
    <tbody>
    </tbody>
  </table>
</div>
'''

ReserveClassmateBookView = Backbone.View.extend({
  el: "body"

  #  "click .add-or-buy-or-reserve .buy-book" : "buy_book"
  #buy_book: -> alert("sorry, not implemented yet")

  initialize: ->
    @el = $(reserve_book_template)
    $.get('/book_ownerships/0', {isbn: @model.get('isbn').toString()}, (book_ownerships) =>
      books_available = book_ownerships.length != 0
      @el.find('.reserve-book').toggle(books_available)
      if !books_available
        @el.find('.finding-owners').text("Sorry, no classmates found with this book!")
      else
        @el.find('.finding-owners').hide()
      
      _(book_ownerships).each( (book_ownership) =>
        view = new ClassmateBookView(model: @model, dialog: @el, book_ownership: book_ownership)
        @el.find(".found-owners").append(view.render().el)
      )
    )

  render: ->
    this
})

ClassmateBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"

  events:
    'mousedown span.reserved': "reserve_book"

  reserve_book: (e) ->
    e.preventDefault()
    @model.id = @options['book_ownership'].id
    @options['dialog'].dialog('close')
    SearchedBooks.transfer_to(ReservedBooks, @model, reserve : true)

  initialize: ->
    _.bindAll(this, 'render')
    @template = _.template('''
      <td><span class="reserved">Reserve</span></td>
      <td class='condition'><%= condition %></td>
      <td class='description'><%= condition_description %></td>
    ''')

  render: ->
    $(@el).html(@template(@options['book_ownership']))
    this
)

BooksAppView = Backbone.View.extend({
  el: "body"

  events:
    'submit .search-book-form': "search"

  search: (e) ->
    e.preventDefault()
    form = $(e.currentTarget)
    @form_id = form.attr('id')
    query = form.find('input[type=search]').serialize()
    show_books()
    if query.length > 0
      # no need for a url
      $('.bookfound').addClass('ui-helper-hidden')
      $.getJSON('/books/search', query, (books) ->
        $('.bookfound').removeClass('ui-helper-hidden')
        SearchedBooks.reset(books)
      )

  save: (e) ->
    book = new OwnedBooks.model(form_to_json(e)['book'])
    book.save()
    e.currentTarget.reset()
    OwnedBooks.add(book)

  addAllSearched: (books) ->
    searched_books_table.find('tbody').empty()
    show_books
    SearchedBooks.each(this.addSearched)

  addSearched: (book) ->
    console.log(book)
    view = new SearchedBookView({model: book, reserve: @form_id == "reserve-book-form"})
    searched_books_table.find('tbody').append(view.render().el)

  addReserved: (book) ->
    view = new ReservedBookView({model: book})
    books_table.find('tbody').append(view.render().el)

  addAllReserved: (books) ->
    ReservedBooks.each(this.addReserved)

  initialize: ->
    _.bindAll(this, 'addOwned', 'addAllOwned', 'addSearched', 'addAllSearched', 'addReserved', 'addAllReserved')
    OwnedBooks.bind('add', this.addOwned)
    OwnedBooks.bind('reset', this.addAllOwned)
    OwnedBooks.bind('remove', UndoRemovedBooks.add)

    SearchedBooks.bind('add', this.addSearched)
    SearchedBooks.bind('reset', this.addAllSearched)

    ReservedBooks.bind('add', this.addReserved)
    ReservedBooks.bind('reset', this.addAllReserved)

    OwnedBooks.fetch()
    if OwnedBooks.length == 0
      $('#my-book-quanity').text(' - None-yet')

    ReservedBooks.fetch()
    if ReservedBooks.length == 0
      $('#reserved-book-quanity').text(' - None-yet')

  addOwned: (book) ->
    book.set(reserver_id: null) if !book.get('reserver_id')
    view = new OwnedBookView({model: book})
    books_table.find('tbody').append(view.render().el)
    #$('#my-book-quanity').text('')

  addAllOwned: ->
    books_table.find('tbody').empty()
    OwnedBooks.each(this.addOwned)

    # TODO: use requests views
    #for book in _(OwnedBooks.filter((b)->b.requested)).concat(ReservedBooks.models).sortBy((b) -> b.updated_at)
      #view = if b.reserver_id == CURRENT_USER['id']
        #new ReserveRequestView(model:book)
      #else if b.offered_at
        #new OfferedRequestView(model:book)
      #else if b.accepted_at
        #new AccepteRequestView(model:book)
      #else
        #requests_table.find('tbody').append(view.render().el)
})

window.books_table = null
window.searched_books_table = null
window.requesets_table = null


window.show_books = (e) ->
  communication_content.addClass('ui-helper-hidden')
  posts_container.addClass('ui-helper-hidden')
  searched_books_table.removeClass('ui-helper-hidden')

$(->
  window.requests_table = $('#requests-table')
  window.books_table = $('#books-table')
  window.searched_books_table = $('#searched-books-table')
  window.BooksApp = new BooksAppView
  window.add_course_name = $("<div><p>What course is this for?</p></p><form><input type='text' id='add-course-name'></input></form></div>")
  # jquery ui dialog screws up event bindings, see:
  # https://groups.google.com/group/backbonejs/browse_thread/thread/fa9d2969608e59d7

  fast_click($('.book-space .listbook'), ->
    $("#new-book-form").toggleClass('ui-helper-hidden')
  )
  
  fast_click($('.book-space .reservebook'), ->
    $("#reserve-book-form").toggleClass('ui-helper-hidden')
  )
)

#AddBookView = Backbone.View.extend({
  #el: "body"

  #events:
    #"mousedown .add-to-my-books": "add_book"
  ##  "click .add-or-buy-or-reserve .buy-book" : "buy_book"
  ##buy_book: -> alert("sorry, not implemented yet")

  #add_book: (e) ->
    #)

  #initialize: ->
    #@el = $(add_book_template)

  #render: ->
    #books_table.find('tbody').prepend(@el)
    #this
#})

#add_book_template = '''
#<div>
  #<span class="add-to-my-books"> <span class="reserved">Add</span> I own this book already! </li>
#</div>
#'''
