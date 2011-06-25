class RegistrationsController < Devise::RegistrationsController
  def create
   session[:user_return_to]= "/home/welcome"
    super
  end
end