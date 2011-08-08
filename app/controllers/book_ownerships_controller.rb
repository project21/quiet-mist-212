class BookOwnershipsController < ApplicationController
  respond_to :json
  before_filter :load_resource, :only => [:reserve, :decline, :accept]
  
  def index
    respond_with current_user.books.select('"books".*, "book_ownerships".reserver_id')
  end

  def reserved
    respond_with BookOwnership.where(:reserver_id => current_user.id).map(&:book)
  end

  def show
    book = Book.find_by_isbn(params[:isbn])
    respond_with(if !book then [] else
      BookOwnership.where(
        :school_id => current_user.school_id, :book_id => book.id
      ).includes(:book)
    end)
  end

  def create
    unless bo_params = params[:book_ownership]
      render :json => 'no params', :status => :unprocessable_entity
      return
    end

    @book = Book.find_by_isbn(bo_params[:isbn]) || Book.new(bo_params)
    if @book.save
      BookOwnership.create!(:user => current_user, :book => @book, :course_id => bo_params[:course_id])
      respond_with @book
    else
      respond_with @book, :status => :unprocessable_entity
    end
  end

  def reserve
    if @book_ownership.reserve!(current_user, params[:amount])
      respond_with @book_ownership
    else
      respond_with @book_ownership, :status => :unprocessable_entity
    end
  end

  def decline
    @book_ownership.reject!  
  end
 
  def accept
    @book_ownership.accept!
  end

protected

  def load_resource
    @book_ownership = BookOwnership.where(:school_id => current_user.school_id).find(params[:id])
  end
end
