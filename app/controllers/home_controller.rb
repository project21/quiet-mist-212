class HomeController < ApplicationController
  before_filter :registered!, :only => 'show'

  def show
    @books = current_user.books
    @javascript = ['application']
  end
  
  def profile
    @books = current_user.books
  end
  
  def edit
  end

  def setting
    
  end
  
  def welcome
    @school = School.all
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
