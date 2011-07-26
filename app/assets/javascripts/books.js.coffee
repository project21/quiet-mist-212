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
  # no need for a url
  search : (query) ->
    $.getJSON('/books/search', query, (books) ->
      $('#notifications-table').empty()
      _.each(books, (b) -> SearchedBooks.add(b))
    )
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
  el: "#book-app"

  events:
    'submit #new_book': "save"

  save: (e) ->
    e.preventDefault()
    query = $(e.currentTarget).serialize()
    if query.length > 0
      SearchedBooks.search(query)

    #book = new OwnedBooks.model(form_to_json(e)['book'])
    #book.save()
    #e.currentTarget.reset()
    #OwnedBooks.add(book)

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    OwnedBooks.bind('add', this.addOne)
    OwnedBooks.bind('reset', this.addAll)
    OwnedBooks.fetch()

  addOne: (book) ->
    view = new BookView({model: book})
    # TODO: add class if it is reserved
    this.$("#books-table").append(view.render().el)

  addAll: ->
    OwnedBooks.each(this.addOne)
})

$(->
  window.BooksApp = new BooksAppView
  # jquery ui screws up event bindings, see:
  # https://groups.google.com/group/backbonejs/browse_thread/thread/fa9d2969608e59d7
)
