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

  status: ->
    if @get('reserver_id')
      if !@get('accepted_at')
        'pending'
      else
        'reserved'

  view_attributes: ->
    attrs = _.clone(@attributes)
    attrs.status = @status()
    attrs
)

BookOwnershipCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships'
)
BookReservedCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships/reserved'
  pending: -> @filter (book) -> book.status() == 'pending'
)
BookSearchCollection = Backbone.Collection.extend(
  model : Book
  transfer_to: (collection, book, options) ->
    this.remove(book)
    collection.add(book)
    if options && options['reserve']
      book.reserve()
    else
      book.save()
)

window.OwnedBooks       = new BookOwnershipCollection
window.UndoRemovedBooks = new BookOwnershipCollection
window.SearchedBooks    = new BookSearchCollection
window.ReservedBooks    = new BookReservedCollection

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
      <td class='title'><a href="#"><%= title %></a></td>
      <td class='edition'><%= edition %></td>
      <td class='author'><%= author %></td>
      <td><span class='<%= status %>'><%= capitalize(status) %></span></td>
    ''')

  render: ->
    $(@el).html(@template(@model.view_attributes()))
    this
)


CampusMachineView = Backbone.View.extend(
  stop_event : (e) -> e.preventDefault()
)

ReservedBookView = CampusMachineView.extend(
  tagName:  "tr"
  className:  "book"
  
  events:
    'click td.title': "search_again"

  search_again: (e) ->
    e.preventDefault()
    $("#reserve-book-form :input").val($(e.currentTarget).text()).submit()

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
      <td><span class='<%= status %>'><%= capitalize(status) %></span></td>
    ''')

  render: ->
    $(@el).html(@template(@model.view_attributes()))
    this
)

SearchedBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"
  
  events:
    'click td': "choose_book"

  choose_book: (e) ->
    e.preventDefault()

    if @options['reserve']
      SearchedBooks.each (book) =>
        $(book.view.el).hide() unless book.get('isbn') == @model.get('isbn')
      new ReserveClassmateBookView(model: @model)
      classmates_books_table.find('tbody').empty()
      classmates_books_table.removeClass('ui-helper-hidden')
    else
      add_course_field = $('#add-course-name')
      add_course_name.dialog
        buttons:
          cancel: ()->$(this).dialog("close")
          save: () ->
            add_course_field.trigger('autocompleteselect')
            $(this).dialog("close")

      autocomplete_courses add_course_field, (course_id) =>
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
      <td ><button>Add</button></td> 
    ''')

  render: ->
    # TODO cutoff title after x chars
    # TODO cutoff authors after 1 author
    $(@el).html(@template(@model.attributes))
    this
)


ReserveClassmateBookView = Backbone.View.extend({
  el: "body"

  initialize: ->
    $.get('/book_ownerships/0', {isbn: @model.get('isbn').toString()}, (book_ownerships) =>
      books_available = book_ownerships.length != 0

      if !books_available
        classmates_books_table.prepend("<tr class='no-classmates-found'><td>Sorry, no classmates found with this book</td></tr>")
          .effect('highlight', 2000)
      else
        $_('#finding-classmate-book-owners').removeClass('ui-helper-hidden')
        _(book_ownerships).each( (book_ownership) =>
          view = new ClassmateBookView(model: @model, book_ownership: book_ownership)
          classmates_books_table.append(view.render().el)
        )
    )
  render: -> this
})

ClassmateBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"

  events:
    'mousedown span.reserved': "reserve_book"

  reserve_book: (e) ->
    e.preventDefault()
    @model.id = @options['book_ownership'].id
    @model.set(reserver_id: CURRENT_USER.id)
    SearchedBooks.transfer_to(ReservedBooks, @model, reserve : true)

  initialize: ->
    _.bindAll(this, 'render')
    # TODO: add user
    @template = _.template('''
      <td><img src="<%= user.image_url %>"/></td>
      <td><span class="full_name"> <%= user.firstname %> <%= user.lastname %></span></td>
      <td class='condition'><%= condition %></td>
      <td class='description'><%= condition_description %></td>
      <td><button class="reservebutton">Reserve</button></td>

     
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
    show_searched_books()
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
    show_searched_books
    SearchedBooks.each(this.addSearched)

  addSearched: (book) ->
    view = new SearchedBookView({model: book, reserve: @form_id == "reserve-book-form"})
    searched_books_table.find('tbody').append(view.render().el)

  initialize: ->
    _.bindAll(this, 'addOwned', 'addAllOwned', 'addSearched', 'addAllSearched', 'addReserved', 'addAllReserved')
    OwnedBooks.bind('add', this.addOwned)
    OwnedBooks.bind('reset', this.addAllOwned)
    OwnedBooks.bind('remove', UndoRemovedBooks.add)

    SearchedBooks.bind('add', this.addSearched)
    SearchedBooks.bind('reset', this.addAllSearched)

    ReservedBooks.bind('add', this.addReserved)
    ReservedBooks.bind('reset', this.addAllReserved)

    # TODO: separate tables for owned and reserved?
    books_table.find('tbody').empty()
    OwnedBooks.fetch()
    if OwnedBooks.length == 0
      $('#my-book-quanity').text(' - None-yet')

    ReservedBooks.fetch()
    if ReservedBooks.length == 0
      $('#reserved-book-quanity').text(' - None-yet')

  addViewToBooksTable: (view) ->
    el = books_table.find('tbody').prepend(view.render().el)
    el.effect('highlight', 2000) unless @noHighlight

  addReserved: (book) ->
    view = new ReservedBookView({model: book})
    @addViewToBooksTable(view)

  addOwned: (book) ->
    book.set(reserver_id: null) if !book.get('reserver_id')
    view = new OwnedBookView({model: book})
    @addViewToBooksTable(view)

  withoutHighlight: (f) ->
    @noHighlight = true
    f()
    @noHighlight = false

  addAllReserved: ->
    @withoutHighlight => ReservedBooks.each(@addReserved)

  addAllOwned: ->
    @withoutHighlight => OwnedBooks.each(@addOwned)
})

window.books_table = null
window.searched_books_table = null
window.requesets_table = null


window.show_searched_books = ->
  hide_main_requests()
  hide_main_posts()
  container.addClass('ui-helper-hidden')
  classmates_books_table.addClass('ui-helper-hidden')
  searched_books_table.removeClass('ui-helper-hidden')

window.hide_main_books = ->
  classmates_books_table.addClass('ui-helper-hidden')
  searched_books_table.addClass('ui-helper-hidden')
  container.removeClass('ui-helper-hidden')

$(->
  window.requests_table = $('#requests-table')
  window.books_table = $('#books-table')
  window.container=$('.container')
  window.searched_books_table = $('#searched-books-table')
  window.classmates_books_table = $('#classmates-books-table')
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
