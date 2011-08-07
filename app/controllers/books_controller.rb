class BooksController < ApplicationController
  respond_to :json

  def search
    if bookp = params['book'] and search = bookp['title']
        result = begin
                   fail
                   # TODO: check that printType=books is used
                   Google::Book.search(search)
                 rescue
                   MOCK_BOOK_DATA if Rails.env.development?
                 end

# is this how you get edition? http://books.google.com/books/feeds/volumes?q=editions:ISBN0451198492&lr=en
      respond_with result.map { |b|
        { :title => b.title,
          :author => b.hash['dc:creator'],
          :isbn => b.isbn,
          :edition => b.hash["dc:date"]
        }
      }
    end
  end

MOCK_BOOK_DATA = [
  Struct.new(:title, :isbn, :hash).new('Programming Ruby', '1234567', {"id"=>"http://www.google.com/books/feeds/volumes/f89GPgAACAAJ", "updated"=>"2011-07-24T07:48:16.000Z", "category"=>{"scheme"=>"http://schemas.google.com/g/2005#kind", "term"=>"http://schemas.google.com/books/2008#volume"}, "title"=>"Programming Ruby 1.9", "link"=>[{"rel"=>"http://schemas.google.com/books/2008/thumbnail", "type"=>"image/x-unknown", "href"=>"http://bks4.books.google.com/books?id=f89GPgAACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_gdata"}, {"rel"=>"http://schemas.google.com/books/2008/info", "type"=>"text/html", "href"=>"http://books.google.com/books?id=f89GPgAACAAJ&dq=programming+ruby&ie=ISO-8859-1&source=gbs_gdata"}, {"rel"=>"http://schemas.google.com/books/2008/preview", "type"=>"text/html", "href"=>"http://books.google.com/books?id=f89GPgAACAAJ&dq=programming+ruby&ie=ISO-8859-1&cd=1&source=gbs_gdata"}, {"rel"=>"http://schemas.google.com/books/2008/annotation", "type"=>"application/atom+xml", "href"=>"http://www.google.com/books/feeds/users/me/volumes"}, {"rel"=>"alternate", "type"=>"text/html", "href"=>"http://books.google.com/books?id=f89GPgAACAAJ&dq=programming+ruby&ie=ISO-8859-1"}, {"rel"=>"self", "type"=>"application/atom+xml", "href"=>"http://www.google.com/books/feeds/volumes/f89GPgAACAAJ"}], "gbs:contentVersion"=>"preview-1.0.0", "gbs:embeddability"=>{"value"=>"http://schemas.google.com/books/2008#not_embeddable"}, "gbs:openAccess"=>{"value"=>"http://schemas.google.com/books/2008#disabled"}, "gbs:viewability"=>{"value"=>"http://schemas.google.com/books/2008#view_no_pages"}, "dc:creator"=>["Dave Thomas", "Chad Fowler", "Andy Hunt"], "dc:date"=>"2009", "dc:format"=>["930 pages", "book"], "dc:identifier"=>["f89GPgAACAAJ", "ISBN:1934356085", "ISBN:9781934356081"], "dc:language"=>"en", "dc:publisher"=>"Pragmatic Bookshelf, The", "dc:title"=>["Programming Ruby 1.9", "the pragmatic programmers' guide"]}
  )
]
  
end
