require 'spec_helper'

describe Post do
  before { @p = make_post! }

  it "is about a users course" do
    @p.should be_valid
    course_id = @p.course_id
    @p.update_attributes(:course_id => nil).should be_false
    @p.update_attributes(:course_id => Course.make!.id).should be_false
    @p.update_attributes(:course_id => course_id).should be_true
  end
end
