class SessionsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!
  skip_before_filter :user_required
  skip_before_filter :registered!
end
