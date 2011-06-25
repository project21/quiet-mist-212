class BooksController < ApplicationController
  def index
   
  end
  
  def create
    
    @book=current_user.books.build(params[:book])
    if @book.save
    redirect_to '/home/index'
    else
      render :action =>'new'
    end
  end
  
  
  def new
    @book=Book.new
  end

  def delete
    @user=current_user
    @user.Book.find(params[:id]).destroy
  end

end
