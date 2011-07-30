class RegistrationsController < Devise::RegistrationsController
  def create
    session[:user_return_to]= "/home/welcome"
    super
    session[:omniauth] = nil unless @user.new_record?   
  end

  def update
    uparams = params[:user]
    if uparams and uparams.delete(:school_name) or hs = uparams.delete('highschool')
      current_user.highschool = hs if hs.present?
      current_user.set_school_id uparams[:school_id]
      if current_user.save
        head :ok
      else
        respond_with current_user, :status => :unprocessable_entity
      end
    else
      super
    end
  end

  def registered
    current_user.register!
    redirect_to '/home/show'
  end

private  
  def build_resource(*args)  
    super  
    if session[:omniauth]  
      @user.apply_omniauth(session[:omniauth])  
      @user.valid?  
    end  
  end 

end
