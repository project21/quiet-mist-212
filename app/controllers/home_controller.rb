class HomeController < ApplicationController
  def index
 #@books = current_user.books.all
   @books=Book.all
  end
  
def show
   @books=Book.all
end
  
  def edit
  end
def welcome
  
end

def skip
   redirect_to '/home/index'
end
 
 def authenticate_user!
    unless user_signed_in?
      redirect_to new_registration_path(:user)
      return  false
    end
  end
end
