require 'spec_integration_helper'
#require 'capybara/save_and_open_page'
#include Capybara::SaveAndOpenPage
#open_in_browser html

describe "A new user" do
  def screen_shot_and_save_page
    require 'capybara/util/save_and_open_page'
    path = "/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"
    png = Capybara.save_and_open_page_path + "#{path}.png"
    page.driver.render Rails.root.join(png)
    html = "#{path}.html"
    Capybara.save_page body, html
    puts png, html
  rescue Capybara::Driver::Webkit::WebkitInvalidResponseError
    puts "ERROR!"
  end

  it "allows new users to register with an email address and password" do
    visit "/users/sign_up"

    #fill_in "First name",            :with => "first"
    #fill_in "Last name",             :with => "last"
    fill_in "Email",                 :with => "first-last@example.com"
    fill_in "Password",              :with => "secret"
    fill_in "Password confirmation", :with => "secret"

    click_button "Sign up"
    screen_shot_and_save_page

    page.should have_content("Welcome! You have signed up successfully.")
  end
=begin
  it "allows users to sign in after they have registered" do
    user = User.create(:email    => "alindeman@example.com",
                       :password => "ilovegrapes")

    visit "/users/sign_in"

    fill_in "Email",    :with => "alindeman@example.com"
    fill_in "Password", :with => "ilovegrapes"

    click_button "Sign in"

    screen_shot_and_save_page
    page.should have_content("Signed in successfully.")
  end
=end
end
