class BookOwnershipsController < ApplicationController
  respond_to :json
  
  def index
    respond_with current_user.books
  end

  def edit; end

  #def new; end
  #def destroy; end

  def create
    @book = Book.new(params[:book])
    if @book.save
      BookOwnership.create!(:user => current_user, :book => @book)
      render :json => @book, :status => :created,
    else
      render :json => @book, :status => :unprocessable_entity
    end
  end

  def show
    @book = Book.find(params[:id])
  end
end
