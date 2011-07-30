class CoursesController < ApplicationController
  respond_to :json

  def index
    respond_with current_user.school.courses
  end

  def create
    subject = (params[:course] || {})[:subject]
    course = current_user.school.courses.build(:subject => subject)
    if course.save
      respond_with course
    else
      respond_with course, :status => :unprocessible_entity
    end
  end
end
