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
    school_id { create(:school).id }
  end

  factory :book do
    title   { "Physics" }
    author  { "Weber" }
    edition { '1' }
    sequence(:isbn) {|sn| sn.to_s }
  end

  factory :book_ownership do
    user { create(:user) }
    book { create(:book) }
    course { create(:course) }
  end

  factory :course do
    school_id { create(:school).id }
    name { "Course 1" }
  end

  factory :user_course do
    active { true }
    user_id { create(:user).id }
    course_id { create(:course).id }
  end

  factory :post do
    content { "Posting..." }
  end
end

def make_post! post_attributes = {}
  cids = post_attributes.delete(:course_ids) || (uc = create(:user_course)).id
  create(:post, { :user_id => post_attributes.delete(:user_id) || uc.user_id,
               :course_id => cid
             }.merge(post_attributes))
end
