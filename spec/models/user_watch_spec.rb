# encoding: utf-8
require 'spec_helper'

describe UserWatch do
  let(:user) { create :user }
  let(:url) { 'link.info' }


  it "should not be valid" do
    user_watch = described_class.new :url=> '', :user_id => user.id
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should not be valid" do
    user_watch = described_class.new :url=> url, :user_id => ''
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should not be valid" do
    described_class.create :url=> url, :user_id => user.id
    user_watch = described_class.new :url=> url, :user_id => user.id
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should be valid and create UserWatch" do
    user_watch = described_class.new :url => url, :user_id => user.id
    user_watch.should be_valid
    user_watch.save.should eq true
    described_class.all.count.should eq(1)
  end

end
