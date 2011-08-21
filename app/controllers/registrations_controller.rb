class RegistrationsController < Devise::RegistrationsController
  def create
    session[:user_return_to]= welcom_home_url
    super
    session[:omniauth] = nil unless @user.new_record?   
  end

  def update
    uparams = params[:user]
    if uparams and [ uparams.delete(:school_name),
                     hs = uparams.delete('highschool'),
                     uparams.delete('major_name')
                   ].any?
      if major_id_p = uparams.delete('major_id') and (major_id = major_id_p.to_i) != 0
        current_user.major = Major.find(major_id).name
      end
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
    redirect_to home_url
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
