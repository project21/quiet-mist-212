require 'spec_helper'

describe Post do
  before do
    @user = create(:user)
  end

  it "creates duplicate posts for each class" do
    course_ids = (1..3).map {|i| create(:user_course, :user => @user, :user_id => @user.id).course_id }
    lambda {
      make_post! :user_id => @user.id, :course_ids => course_ids
    }.should change(Post, :count).by(3)
  end

  describe "new post" do
    before { @p = make_post!(:user_id => @user.id) }

    it "is about a users course" do
      @p.should be_valid
      course_id = @p.course_id
      @p.course_id = nil
      @p.save.should be_false
      @p.course_id = create(:course).id
      @p.save.should be_false
      @p.course_id = course_id
      @p.should be_true
    end
  end
end
