Book = Backbone.Model.extend(
  url: -> if @id then '/books/' + @id else '/books'
)

BookCollection = Backbone.Collection.extend(
  model : Book
  url: '/books'
  first_editions: -> filter((book) -> book['edition'] == '1')
)

window.Books = BookCollection.new

BookView = Backbone.View.extend(
  tagName:  "tr"
  
  createBook: (e) ->
    e.preventDefault()
    collection.create($(e.current_target).serializeObject())
    @model

  initialize: ->
    _.bindAll(this, 'render')
    @model.bind('change', this.render)
    @model.view = this
    @template = _.template('''
        <tr>
          <td><%= title %></td>
          <td><%= edition %></td>
          <td><%= author %></td>
        </tr>
    ''')

  render: ->
    $(@el).html(@template(@model.toJSON()))
    this
)

BooksAppView = Backbone.View.extend({
  el: "#book-app"

  events: # $('form').submit(save)
    'submit form': "save"

  save: (e) ->
    # msg = @model.isNew() ? 'Successfully created!' : "Saved!"
    this.model.save(form_to_json(e))

  initialize: ->
    _.bindAll(this, 'render')
    this.model.bind('change', this.render)
    this.render()
})

$(->
  window.BooksApp = new BooksAppView( model : new Book )
)
