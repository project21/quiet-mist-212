require 'factory_girl'
#require 'factory_girl/active_record'

FactoryGirl.define do
  factory :school do
    sequence(:name) {|sn| "State University #{sn}" }
    postal_code { 95816 }
  end

  factory :user do
    sequence(:email) {|sn| "#{sn}@example.com" }
    password {'secret' }
    password_confirmation { 'secret' }
    firstname { "First" }
    lastname { "Last" }
    school
  end

  factory :book do
    title   { "Physics" }
    author  { "Weber" }
    edition { '1' }
    sequence(:isbn) {|sn| sn.to_s }
  end

  factory :book_ownership do
    user
    book
    course
  end

  factory :course do
    school
    name { "Course 1" }
  end

  factory :user_course do
    active { true }
    user
    course
  end

  factory :post do
    content { "Posting..." }
  end
end

def make_post! post_attributes = {}
  cids = post_attributes.delete(:course_ids) || (uc = FactoryGirl.create(:user_course)).id
  FactoryGirl.create(:post, { :user_id => post_attributes.delete(:user_id) || uc.user_id,
               :course_id => cids
             }.merge(post_attributes))
end
