class BookOwnershipsController < ApplicationController
  respond_to :json
  before_filter :load_resource, :only => [:reserve, :decline, :accept]
  
  def index
    respond_with current_user.books.select('"books".*, "book_ownerships".reserver_id')
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

  def reserve
    book_ownership.reserve!(params[:reserver_id], params[:amount])
  end

  def decline
    book_ownership.reject!  
  end
 
  def accept
    book_ownership.accept!
  end

protected

  def load_resource
    @book_ownership = BookOwnership.find params[:id]
  end
end
