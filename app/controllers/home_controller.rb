class HomeController < ApplicationController
  #kip_before_filter    :authenticate_user! 
  #efore_filter :homenticate_user! 

  def index
    @books=current_user.books
    
  end

  def show
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