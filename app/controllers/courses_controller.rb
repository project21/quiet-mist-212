class CoursesController < ApplicationController
  respond_to :json

  def create
    current_user.courses.create!(params[:course])
  end
end
