class BookOwnershipsController < ApplicationController
  respond_to :json
  
  def index
    respond_with current_user.books
  end

  def create
    unless bo_params = params[:book_ownership]
      render :json => 'no params', :status => :unprocessable_entity
      return
    end

    @book = Book.find_by_isbn(bo_params[:isbn]) || Book.new(bo_params)
    if @book.save
      BookOwnership.create!(:user => current_user, :book => @book)
      respond_with @book
    else
      respond_with @book, :status => :unprocessable_entity
    end
  end
end
