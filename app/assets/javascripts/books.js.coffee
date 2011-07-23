_.extend Backbone.Model.prototype,
  toJSON : ->
    csrfName = $("meta[name='csrf-param']").attr('content')
    csrfValue = $("meta[name='csrf-token']").attr('content')
    object = {}
    object[csrfName] = csrfValue
    object[@model_name] =
       _.clone(@attributes)
    object

Book = Backbone.Model.extend(
  url: -> if @id then '/books/' + @id else '/books'
  model_name: 'book'
)

BookCollection = Backbone.Collection.extend(
  model : Book
  url: '/books'
)

window.Books = new BookCollection

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
    book = new Books.model(form_to_json(e)['book'])
    book.save()
    e.currentTarget.reset()
    Books.add(book)

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll')
    Books.bind('add', this.addOne)
    Books.bind('reset', this.addAll)
    Books.fetch()

  addOne: (book) ->
    view = new BookView({model: book})
    # TODO: add class if it is reserved
    this.$("#books-table").append(view.render().el)

  addAll: ->
    Books.each(this.addOne)
})

$(->
  window.BooksApp = new BooksAppView
  # jquery ui screws up event bindings, see:
  # https://groups.google.com/group/backbonejs/browse_thread/thread/fa9d2969608e59d7
  $('.addbookbutton').live('click', (e)->
    e.preventDefault()
  )
)
