require 'spec_helper'

describe BookOwnership do
  before { @bo = create(:book_ownership) }

  it do
    should_not be_reserved
    should_not be_accepted
    should_not be_condition_new
    should_not be_condition_like_new
    should be_condition_used
  end

  it "try to reserve own book" do
    lambda { @bo.reserve! @bo.user, 20 }.should raise_error(ActiveRecord::RecordInvalid)
    @bo.should_not be_reserved
    @bo.should_not be_valid
  end

  describe 'reserved' do
    before do
      @bo.reserve! create(:user), 20
      @bo.should be_valid
    end

    it 'accept' do
      @bo.should_not be_accepted
      @bo.accept!
      @bo.should be_accepted

      @bo.cancel!
      @bo.should_not be_accepted
      @bo.should_not be_reserved
    end

    it 'reject' do
      @bo.should be_reserved
      @bo.reject!
      @bo.should_not be_reserved
    end
  end
end
