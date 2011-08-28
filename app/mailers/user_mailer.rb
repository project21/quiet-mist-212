class UserMailer < ActionMailer::Base
  default from: "info@campusmachine.com"
  
  def test_mail(user)
    @user=user
    mail(:to => user.email, :subject => "Book reserve request")
  end
end
