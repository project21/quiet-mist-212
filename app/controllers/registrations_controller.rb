class RegistrationsController < Devise::RegistrationsController
  def create
    session[:user_return_to]= "/home/welcome"
    super
    session[:omniauth] = nil unless @user.new_record?   
  end

  def update
    if uparams = params[:user] and uparams.delete(:school_name)
      school_id = uparams[:school_id].to_i
      if current_user.set_school_id school_id
        current_user.save!
        head :ok
      else
        render :json => ["school_id", "could not set to #{school_id}"], :status => :unprocessable_entity
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
