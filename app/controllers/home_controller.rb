class HomeController < ApplicationController
  def show
    #@books = current_user.books.all
    @books=Book.all
  end
  
  def profile
    @books=Book.all
  end
  
  def edit
  end

  def welcome
  end

protected
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_registration_path(:user)
      return  false
    end
  end
end
