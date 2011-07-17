class CourseController < ApplicationController
  def create

	respond_to :json
  def create
  	 @course = current_user.courses.build(params[:course].merge(:user => current_user))
    if @course.save
      respond_with @course
    else
      respond_with @course.errors, :status => :unprocessable_entity
    end

  end

end
