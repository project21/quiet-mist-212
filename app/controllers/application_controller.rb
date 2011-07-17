class ApplicationController < ActionController::Base
  before_filter :authenticate_user! 
  protect_from_forgery
  
  def registered!
    unless current_user.registered
      redirect_to '/home/welcome'
    end
  end
end
