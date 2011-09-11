class SettingController < ApplicationController
  def privacy
  end

  def notification
  end

  def show
    @books=Book.all
  end
end
