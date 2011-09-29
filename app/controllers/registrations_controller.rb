class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!, :only => :create
  skip_before_filter :user_required
  skip_before_filter :registered!

  def create
    session[:user_return_to]= welcome_home_url
    super
    session[:omniauth] = nil unless @user.new_record?   
  end

  def update
    respond_to do |format|
      format.html { super }
      format.js do

        uparams = params[:user]
        if uparams and uparams.delete(:school_name)
          current_user.set_school_id uparams.delete(:school_id)
        end
        if uparams and uparams.delete('major')
          if major_id_p = uparams.delete('major_id') and (major_id = major_id_p.to_i) != 0
            current_user.major = Major.find(major_id).name
          end
        end

        if uparams.present?
          current_user.attributes = uparams
        end
        if current_user.save
          head :ok
        else
          respond_with current_user, :status => :unprocessable_entity
        end
      end
    end
  end

  def registered
    if current_user.register!
      redirect_to home_url
    else
      redirect_to welcome_home_url
    end
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
