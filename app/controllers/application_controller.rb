class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :registered!
  protect_from_forgery
  
protected
  def registered!
    redirect_to welcome_home_url unless current_user.registered
  end

  def to_boolean param
    param.present? and (not ["false","0"].include? param)
  end
end
