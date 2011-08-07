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
)

BookOwnershipCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships'
)
BookSearchCollection = Backbone.Collection.extend(
  model : Book
  transfer_to: (collection, book) ->
    this.remove(book)
    book.set(reserver_id: null)
    collection.add(book)
    book.save()
)

window.OwnedBooks = new BookOwnershipCollection
window.UndoRemovedBooks = new BookOwnershipCollection
window.SearchedBooks = new BookSearchCollection

OwnedBookView = Backbone.View.extend(
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
     <td ><span class='reserved'>reserved</span></td>
      <td> <% if(reserver_id) {%><span class='reserved'>reserved</span><%}%> </td>  

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
    new ClassmatesBooksView(model: @model)

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

# <li class="buy-book"> <span class="reserved">Buy</span> from Amazon </li>

classmatesTemplate = '''
<div>
  <ul class="add-or-buy-or-reserve">
    <li class="add-to-my-books"> <span class="reserved">Add</span> I own this book already! </li>
    <li class="reserve-book" style="display:none;"> <span class="reserved">Reserve</span> from your classmates</li>
  </ul>
  <p class="finding-owners">
    Looking for classmates with this book ...
  </p>
  <table class="found-owners">
    <tbody>
    </tbody>
  </table>
</div>
'''

ClassmatesBooksView = Backbone.View.extend({
  el: "body"

  events:
    "click .add-or-buy-or-reserve .add-to-my-books": "add_book"
  #  "click .add-or-buy-or-reserve .buy-book" : "buy_book"
  #buy_book: -> alert("sorry, not implemented yet")

  add_book: (e) ->
    e.preventDefault()
    add_course_name.dialog()

    # TODO: must set the course_id
    autocomplete_schools($('#add-course-name'), (course_id) =>
      @model.set(course_id: course_id)
      SearchedBooks.transfer_to(OwnedBooks, @model)
      add_course_name.dialog('close')
      @el.dialog('close').remove()
    )

  initialize: ->
    @el = $(classmatesTemplate)
    $.get('/book_ownerships/0', {isbn: @model.get('isbn').toString()}, (book_ownerships) =>
      books_available = book_ownerships.length != 0
      @el.find('.reserve-book').toggle(books_available)
      if !books_available
        @el.find('.finding-owners').text("Sorry, no classmates found with this book!")
      else
        @el.find('.finding-owners').hide()
      
      _(book_ownerships).each( (book_ownership) =>
        view = new ClassmateBookView(model: @model, dialog: @el, book_ownership : book_ownership)
        @el.find("#found-owners").append(view.render().el)
      )
    )
    @el.dialog()
})

ClassmateBookView = Backbone.View.extend(
  tagName:  "tr"
  className:  "book"

  events:
    'click #found-owners tr': "reserve_book"

  reserve_book: (e) ->
    e.preventDefault()
    SearchedBooks.transfer_to(OwnedBooks, @model)
    @options['dialog'].dialog('close').remove()

  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @template = _.template('''
      <td class='condition'><%= condition %></td>
      <td class='description'><%= condition_description %></td>
      </td>
    ''')

  render: ->
    $(@el).html(@template(@options['book_ownership']))
    this
)

BooksAppView = Backbone.View.extend({
  el: "body"

  events:
    'submit #new_book': "search"

  search: (e) ->
    e.preventDefault()
    query = $(e.currentTarget).serialize()
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
    this.$("#posts-table").empty()
    SearchedBooks.each(this.addSearched)

  addSearched: (book) ->
    view = new SearchedBookView({model: book})
    this.$("#posts-table").append(view.render().el)

  initialize: ->
    _.bindAll(this, 'addOwned', 'addAllOwned', 'addSearched', 'addAllSearched')
    OwnedBooks.bind('add', this.addOwned)
    OwnedBooks.bind('reset', this.addAllOwned)
    OwnedBooks.bind('remove', UndoRemovedBooks.add)

    SearchedBooks.bind('add', this.addSearched)
    SearchedBooks.bind('reset', this.addAllSearched)

    OwnedBooks.fetch()
    if OwnedBooks.length == 0
      $('#my-book-quanity').text(' - None-yet')

  addOwned: (book) ->
    view = new OwnedBookView({model: book})
    $('#my-book-quanity').text('')

    # TODO: add class if it is reserved
    this.$("#books-table").append(view.render().el)

  addAllOwned: ->
    this.$("#books-table").empty()
    OwnedBooks.each(this.addOwned)
})

$(->
  window.BooksApp = new BooksAppView
  window.add_course_name = $("<div><p>What course is this for?</p></p><form><input type='text' id='add-course-name'></input></form></div>")
  # jquery ui screws up event bindings, see:
  # https://groups.google.com/group/backbonejs/browse_thread/thread/fa9d2969608e59d7
)
