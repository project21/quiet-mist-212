class BooksController < ApplicationController
  respond_to :json
  
  def search
    if bookp = params['book'] and search = bookp['title']
      respond_with Google::Book.search(search).map(&:hash)
    end
  end
end
