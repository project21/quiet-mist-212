class RequestsController < ApplicationController
  respond_to :json, :html
  layout "home"
  def index
    respond_with current_user.book_ownerships.recently_requested
  end

  def books
  	 @javascript = ['application']
  end

  def messages
  	  @javascript = ['application']
  end	
end
