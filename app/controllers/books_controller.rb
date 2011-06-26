class BooksController < ApplicationController
  
  def index
  # redirect_to :controller=>"home" ,:action=>"index"

  end

  def edit
  end

  def new
    @book = Book.new
  # redirect_to :controller=>"home" ,:action=>"index"
  end

  def create
    @book=current_user.books.build(params[:book])
    
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
