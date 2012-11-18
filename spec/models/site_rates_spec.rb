# encoding: utf-8
require 'spec_helper'

describe SiteRate do
  let(:user) { create :user }
  let(:email) { 'underveil@yahoo.com' }
  let(:link_url) { 'http://link.info' }

  it "should recount rates from" do
   link = UserLink.new :email => user.email, :link_url => link_url
   link.add
   Domain.count.should eq(1)
  end
end
