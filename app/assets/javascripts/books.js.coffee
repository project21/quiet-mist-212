Book = Backbone.Model.extend(
)

BookCollection = Backbone.Collection.extend(
  model : Book
)
Books = BookCollection.new

BookView = Backbone.View.extend(
  tagName:  "tr"
  model: Book
  collection: Books
  
  createBook: (e) ->
    e.preventDefault()
    Books.create($(e.current_target).serializeObject())
    @model

  initialize: ->
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @model.view = this
    @template = _.template('''
        <tr>
          <td>Book</td>
          <td>Edition</td>
          <td>Author</td>
        </tr>
    ''')

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this
)

BooksAppView = Backbone.View.extend(
  el: $("#bapp")
  model: Book
  collection: Books

  events:
    'submit form#new_book': "createBook"
  
  createBook: (e) ->
    e.preventDefault()
    Books.create($(e.current_target).serializeObject())
    @model

  initialize: ->
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    this.render()
)

BooksApp = new BooksAppView
