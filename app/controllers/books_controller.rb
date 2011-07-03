class BooksController < ApplicationController
  
  def index
    @book ||= Book.new

    if request.xhr?
      render :json => Book.all and return
    end
  end

  def edit
  end

  def new
    @book = Book.new
  # redirect_to :controller=>"home" ,:action=>"index"
  end

  def create
    #@book=current_user.books.build(params[:book])
    @book=Book.new(params[:book])
    
    if @book.save
      render :json => @book, :status => :created,
    else
      render :json => @book.errors, :status => :unprocessable_entity
    end
    # if @book.save
     #redirect_to '/home/index'
   
    #  else
     #render :action=>'new'
     #@book.save
     #respond_to do |format|  
    # format.js
 # end
  end

  def show
    @book = Book.find(params[:id])
  end
end
