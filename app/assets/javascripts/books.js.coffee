_.extend Backbone.Model.prototype,
  toJSON : ->
    csrfName = $("meta[name='csrf-param']").attr('content')
    csrfValue = $("meta[name='csrf-token']").attr('content')
    object = {}
    object[csrfName] = csrfValue
    object[@model_name] =
       _.clone(@attributes)
    object
  url: -> '/' + @model_name  + (if @id then '' else '/' + @id)

Book = Backbone.Model.extend(
  model_name: 'book_ownerships' # used for the url
)

BookOwnershipCollection = Backbone.Collection.extend(
  model : Book
  url: '/book_ownerships'
)
BookSearchCollection = Backbone.Collection.extend(
  model : Book
)

window.OwnedBooks = new BookOwnershipCollection
window.SearchedBooks = new BookSearchCollection

BookView = Backbone.View.extend(
  tagName:  "tr"
  
  initialize: ->
    @model.view = this
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @template = _.template('''
      <td><span class="booktitle"><%= title %></span></td>
      <td><%= edition %></td>
      <td><%= author %></td>
    ''')

  render: ->
    $(@el).html(@template(@model.attributes))
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
      $.getJSON('/books/search', query, (books) ->
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
    SearchedBooks.each(this.addSearched)

  addSearched: (book) ->
    view = new BookView({model: book})
    this.$("#posts-table").append(view.render().el)

  initialize: ->
    _.bindAll(this, 'addOwned', 'addAllOwned', 'addSearched', 'addAllSearched')
    OwnedBooks.bind('add', this.addOwned)
    OwnedBooks.bind('reset', this.addAllOwned)

    SearchedBooks.bind('add', this.addSearched)
    SearchedBooks.bind('reset', this.addAllSearched)

    OwnedBooks.fetch()

  addOwned: (book) ->
    view = new BookView({model: book})
    # TODO: add class if it is reserved
    this.$("#books-table").append(view.render().el)

  addAllOwned: ->
    this.$("#books-table").empty()
    OwnedBooks.each(this.addOwned)
})

$(->
  window.BooksApp = new BooksAppView
  # jquery ui screws up event bindings, see:
  # https://groups.google.com/group/backbonejs/browse_thread/thread/fa9d2969608e59d7
)
