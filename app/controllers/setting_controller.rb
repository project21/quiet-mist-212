class SettingController < ApplicationController
  def privacy
  end

  def notification
  end

  def destroy
  end

  def index
    @books=Book.all
  end

end
