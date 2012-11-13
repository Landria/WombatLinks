# encoding: utf-8
require 'spec_helper'

describe UserWatch do
  let(:user_id) {1}
  let(:url) { 'http://link.info' }


  it "should not be valid" do
    user_watch = described_class.new :url=> '', :user_id => user_id
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should not be valid" do
    user_watch = described_class.new :url=> url, :user_id => ''
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should not be valid" do
    described_class.create :url=> url, :user_id => user_id
    user_watch = described_class.new :url=> url, :user_id => user_id
    user_watch.should_not be_valid
    user_watch.save.should eq false
  end

  it "should not be accessible" do
    user_watch = described_class.new(:url=> url, :user_id => user_id)
    user_watch.save.should eq(true)

    described_class.all.count.should eq(1)
    described_class.accessible?(url, user_id).should eq(false)
  end

  it "should be valid and create UserWatch" do
    user_watch = described_class.new :url => url, :user_id => user_id
    user_watch.should be_valid
    user_watch.save.should eq true
    described_class.all.count.should eq(1)
  end

end
