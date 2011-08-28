class BookOwnershipMailer < ActionMailer::Base
  default from: "info@campusmachine.com"
  
  def test_mail(user)
    @user=user
    mail(:to => user.email, :subject => "Book reserve request")
  end

  def reserve(bo)
  	@book_ownership = bo
    mail(:to => bo.user.email, :subject => "Book reservation request")
  end

  def reject(bo)
  	@book_ownership = bo
  	mail(:to => bo.user.email, :subject => "Book reservation rejected")
  end
  
  def accept(bo)
  	@book_ownership = bo
  	mail(:to => bo.user.email, :subject => "Book reservation accepted")
  end
end
