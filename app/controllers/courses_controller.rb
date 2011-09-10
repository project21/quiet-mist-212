class CoursesController < ApplicationController
  skip_before_filter :registered!
  respond_to :json

  def index
    respond_with current_user.send(active_courses? ? :active_courses : :taken_courses)
  end

  def school
    unless current_user.school
      head 401
      return
    end
    respond_with current_user.school.courses
  end

  def create
    course = if cid = model_params[:id]
      current_user.school.courses.find cid
    else
      name = model_params[:name]
      current_user.school.courses.build(:name => name)
    end

    if !course.new_record? or course.save
      UserCourse.create! :user => current_user, :course => course, :active => active_courses?
      respond_with course
    else
      respond_with course, :status => :unprocessible_entity
    end
  end

  def update
    create
  end

protected
  def model_params
    @model_params ||= (params[:course] || {})
  end

  def active_courses?
    active = params[:active] 
    if active.present? then to_boolean(active)
    else true
    end
  end
end
