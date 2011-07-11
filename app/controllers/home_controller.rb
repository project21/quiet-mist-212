class HomeController < ApplicationController
  def show
    #@books = current_user.books.all
    @books=current_user.books
  end
  
  def profile
    @books=current_user.books
  end
  
  def edit
  end

def setting
  
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
