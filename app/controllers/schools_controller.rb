class SchoolsController < ApplicationController
  respond_to :json
  
  def index
    respond_with School.all
  end
end
