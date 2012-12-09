# encoding: utf-8
require 'spec_helper'

describe CancelMailingList do
  let(:user) {create :user}

  it "should validate" do
    described_class.new(user_id: user.id, list_type: 'rates').should be_valid
    described_class.new(user_id: user.id, list_type: 'monitor').should be_valid
    described_class.new(user_id: user.id, list_type: 'rats').should_not be_valid
    described_class.new(user_id: user.id).should_not be_valid
    described_class.new().should_not be_valid
  end

  it "should change mailing status" do
    described_class.change_status(user.id, 'rates').should eq(true)
    described_class.change_status(user.id, 'monitor').should eq(true)
    described_class.change_status(user.id, 'rats').should eq(false)
  end

end