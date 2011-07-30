class SchoolsController < ApplicationController
  respond_to :json
  
  def index
    respond_with School.all
  end
  
  def create
    @school = current_user.schools.build(params[:school].merge(:user => current_user))

  		 @school = current_user.school.build(params[:school].merge(:user => current_user))

    if @school.save
      respond_with @school
    else
      respond_with @school.errors, :status => :unprocessable_entity
    end
  end

end
