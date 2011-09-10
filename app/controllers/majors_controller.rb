class MajorsController < ApplicationController
  skip_before_filter :user_required, :registered!
  respond_to :json

  def index
    respond_with Major.all
  end
end
