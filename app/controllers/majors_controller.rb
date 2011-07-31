class MajorsController < ApplicationController
  respond_to :json

  def index
    respond_with Major.all
  end
end
