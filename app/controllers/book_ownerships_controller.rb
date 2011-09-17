class BookOwnershipsController < ApplicationController
  respond_to :json
  before_filter :load_resource, :only => [:reserve, :decline, :accept]
  
  def index
    respond_with book_ownership_json(:user_id => current_user.id)
  end

  def reserved
    respond_with book_ownership_json(:reserver_id => current_user.id)
  end

  def show
    book = Book.find_by_isbn(params[:isbn])
    respond_with(if !book then [] else
      BookOwnership.where(
        :school_id => current_user.school_id, :book_id => book.id
      ).includes(:book, :user).to_json(:include => :user)
    end)
  end

  def create
    unless bo_params = params[:book_ownership]
      render :json => 'no params', :status => :unprocessable_entity
      return
    end

    course_id = bo_params.delete(:course_id)
    @book = Book.find_by_isbn(bo_params[:isbn]) || Book.new(bo_params)
    if @book.save
      BookOwnership.create!(:user => current_user, :book => @book, :course_id => course_id)
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
  def book_ownership_json cond
    BookOwnership.where(cond).map do |bo|
      bo.book.attributes.merge(bo.attributes.slice('reserver_id', 'accepted_at'))
    end
  end

  def load_resource
    @book_ownership = BookOwnership.where(:school_id => current_user.school_id).find(params[:id])
  end
end
