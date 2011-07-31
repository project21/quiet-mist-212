class HomeController < ApplicationController
#  before_filter :registered!, :only => 'show'

  def show
    @javascript = ['application']
  end
  
  def profile
    @books = current_user.books
  end
  
  def edit
    @javascript = ['register']
  end

  def setting
    
  end
  
  def welcome
    @javascript = ['register']
  end

protected
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_registration_path(:user)
      return  false
    end
  end
end
