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
    view = if @options['reserve']
      new ReserveClassmateBookView(model: @model)
    else
      new AddBookView(model: @model)
    view.render().el

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


add_book_template = '''
<div>
  <span class="add-to-my-books"> <span class="reserved">Add</span> I own this book already! </li>
</div>
'''
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

AddBookView = Backbone.View.extend({
  el: "body"

  events:
    "mousedown .add-to-my-books": "add_book"
  #  "click .add-or-buy-or-reserve .buy-book" : "buy_book"
  #buy_book: -> alert("sorry, not implemented yet")

  add_book: (e) ->
    e.preventDefault()
    add_course_name.dialog()
    autocomplete_courses($('#add-course-name'), (course_id) =>
      @model.set(course_id: course_id)
      SearchedBooks.transfer_to(OwnedBooks, @model)
      add_course_name.dialog('close')
      @el.dialog('close').remove()
      display_table.find('tr.book').remove()
    )

  initialize: ->
    @el = $(add_book_template)

  render: ->
    display_table.prepend(@el)
    this
})

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
    display_table.prepend(@el)
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
    SearchedBooks.transfer_to(ReservedBooks, @model, reserve : true)
    display_table.empty()

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
    if query.length > 0
      # no need for a url
      $('.bookfound').addClass('ui-helper-hidden')
      $.getJSON('/books/search', query, (books) ->
        $('.bookfound').removeClass('ui-helper-hidden')

        SearchedBooks.reset()
        _(books).each( (book_attrs) ->
          book = new SearchedBooks.model(book_attrs)
          SearchedBooks.add(book)
        )
      )

  save: (e) ->
    book = new OwnedBooks.model(form_to_json(e)['book'])
    book.save()
    e.currentTarget.reset()
    OwnedBooks.add(book)

  addAllSearched: (books) ->
    display_table.empty()
    SearchedBooks.each(this.addSearched)

  addSearched: (book) ->
    view = new SearchedBookView({model: book, reserve: @form_id == "reserve-book-form"})
    display_table.append(view.render().el)

  addReserved: (book) ->
    view = new ReservedBookView({model: book})
    this.$('#books-table tbody').append(view.render().el)

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
    $('#books-table tbody').append(view.render().el)
    #$('#my-book-quanity').text('')

  addAllOwned: ->
    display_table.find('tr.book').remove()
    OwnedBooks.each(this.addOwned)
})

display_table = null
$(->
  display_table = $('#posts-table tbody')
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
