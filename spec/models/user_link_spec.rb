# encoding: utf-8
require 'spec_helper'

describe UserLink do
  let(:email) { 'underveil@yahoo.com' }
  let(:link_url) { 'http://link.info' }

  let(:email_wrong) { 'underveil@.com' }
  let(:link_name_wrong) { 'link' }

  it "should create user_link" do
    user_link = described_class.new :email=>email, :link_url => link_url
    user_link.should be_valid
    user_link.add.should eq true
    user_link.link_hash.should_not be_nil
  end

  it "should not create user_link" do
    user_link = described_class.new :email=>email_wrong, :link_url => link_url
    user_link.should_not be_valid
    user_link.save.should eq false

    user_link = described_class.new :email=>email, :link_url => link_name_wrong
    user_link.should_not be_valid
    user_link.save.should eq false
  end

end
