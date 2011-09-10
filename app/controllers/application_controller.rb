class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :registered!, :user_required
  protect_from_forgery
  
protected
  def registered!
    if current_user
      redirect_to welcome_home_url unless current_user.registered
    end
  end

  def to_boolean param
    param.present? and (not ["false","0"].include? param)
  end

  def user_required
    redirect_to welcome_home_url unless current_user
  end
end
