 class HomesController < ApplicationController
  skip_before_filter :registered!, :only => 'welcome'
  layout :get_layout


  def show
    @javascript = ['application'] 
  end
  
  def profile
   
    @javascript = ['application']
    @books = current_user.books
    @school=current_user.school
    @courses=current_user.courses
    @major=current_user.major
  end
  
  def user_profile
   @javascript = ['application']
    @user=User.find(params[:id])
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
  def get_layout
    if action_name == 'show'
          "home"
    else
      'application'
    end
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_registration_path(:user)
      return  false
    end
  end
end
