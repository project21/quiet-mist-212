class OauthCredentials < Hash
  def key_secret(provider)
    creds = fetch(provider)
    [creds.fetch(:key), creds.fetch(:secret)]
  end
end

OAUTH_CREDENTIALS = OauthCredentials[{
  :twitter => {
    :key => 'CdXyvNaaWo5f4wqMjzao6Q',
    :secret => '6NUf1nu43v3CFLkJsMJIQJvXCqF0h0788shmMYFevw'
  },
  :facebook => {
    :key => '230668783631324',
    :secret => '8713d21f008e58174a8d2beea91f3394'
  }
}]

=begin omniauth broken
Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter,  *OAUTH_CREDENTIALS.key_secret(:twitter)
  provider :facebook, *OAUTH_CREDENTIALS.key_secret(:facebook)
end  

if Rails.env.development?
  OmniAuth.config.full_host = "http://localhost:3000"
else
  OmniAuth.config.full_host = "http://campusmachine.com"
end
=end

# Twitter
# Access token: # 327804893-p6ACPOHCzIwWwfRPIV8zstkVWJ6cowoRlKnj8klA
# Access token secret: mUwr6rGkN40nCOHjOzi5aF5LnPAkBQHNmucGVCJXI
