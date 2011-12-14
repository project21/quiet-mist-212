class ClassGroupsController < ApplicationController
  def index
  end

  def show
  end

  def create
     @class_group=ClassGroup.new
      @course=Course.find(params[:class_group][:course_id])
     @class_group= @course.class_groups.build(params[:class_group])
     if @class_group.save
        redirect_to home_url
     else
        render 'new'
     end
  end

  def new
    @class_group=ClassGroup.new
    @course=Course.find(params[:class_group][:course_id])
    @class_group=@course.class_groups.build
    @class_group.users.build
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
