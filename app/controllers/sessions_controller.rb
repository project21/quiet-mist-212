class SessionsController < Devise::SessionsController
  #skip_before_filter :authenticate_user!
  skip_before_filter :user_required
  skip_before_filter :registered!
end
