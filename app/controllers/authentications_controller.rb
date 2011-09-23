class AuthenticationsController < ApplicationController  
  skip_before_filter :authenticate_user!, :user_required, :registered!

  def index  
    @authentications = current_user.authentications if current_user  
  end  

  def create  
    omniauth = request.env["omniauth.auth"]  
    user = User.from_omniauth(omniauth, current_user)

    if !user.new_record?
      user.save! if user.changed?
      flash[:notice] = "Signed in successfully."  
      sign_in_and_redirect(user)  
    elsif current_user
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url  
    else  
      if user.save
        flash[:notice] = "Signed in successfully."  
        sign_in_and_redirect(user)  
      else  
        # devise can override the normal user_return_to
        #session[:old_user_return_to] = session[:user_return_to] = request.referrer

        session[:omniauth] = omniauth.except('extra')  
        redirect_to new_user_registration_url
      end  
    end
  end  
    
  def destroy  
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to authentications_url  
  end  
end  
