class CoursesController < ApplicationController
  respond_to :json

  def index
    respond_with current_user.active_courses
  end

  def school
    respond_with current_user.school.courses
  end

  def create
    c_params = params[:course] || {}

    course = if cid = c_params[:course_id]
      school.courses.find cid
    else
      subject = c_params[:subject]
      current_user.school.courses.build(:subject => subject)
    end

    if !course.new_record? or course.save
      UserCourse.create! :user => current_user, :course => course, :active => true
      respond_with course
    else
      respond_with course, :status => :unprocessible_entity
    end
  end
end
