class ApplicationController < ActionController::Base
  before_filter :authenticate_user! 
  protect_from_forgery
  
protected
  def registered!
    unless current_user.registered
      redirect_to '/home/welcome'
    end
  end

  def to_boolean param
    param.present? and (not ["false","0"].include? param)
  end
end
