require 'spec_helper'

describe Post do
  it "creates duplicate posts for each class" do
    u = User.make!
    course_ids = (1..3).map {|i| UserCourse.make!(:user => u, :user_id => u.id).course_id }
    lambda {
      make_post! :user_id => u.id, :course_ids => course_ids
    }.should change(Post, :count).by(3)
  end

  describe "new post" do
    before { @p = make_post! }

    it "is about a users course" do
      @p.should be_valid
      course_id = @p.course_id
      @p.course_id = nil
      @p.save.should be_false
      @p.course_id = Course.make!.id
      @p.save.should be_false
      @p.course_id = course_id
      @p.should be_true
    end
  end
end
