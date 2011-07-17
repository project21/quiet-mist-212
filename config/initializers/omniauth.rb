Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 's3dXXXXXXXX', 'lR23XXXXXXXXXXXXXXXXXX'  
  provider :facebook, 's3dXXXXXXXX', 'lR23XXXXXXXXXXXXXXXXXX'  
end  
