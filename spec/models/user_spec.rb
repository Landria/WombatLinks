# encoding: utf-8
require 'spec_helper'

describe User do
  let(:user) { create :user }

  context "can add watch" do
    before do
      Plan.create :name => "name", :price => 0, :sites_count => 1
    end

    it "should return true" do
      Plan.create :name => "name", :price => 0, :sites_count => 1
      user.user_watch.count.should eq(0)
      user.should be_can_add_watch
    end

    it "should return false" do
      UserWatch.create :user_id => user.id, :url => 'google.com'
      user.should_not be_can_add_watch
    end
  end

  context "stats accessible" do
    before do
      plan = Plan.create :name => "name", :price => 0, :sites_count => 1
      UserPlan.create :plan_id => plan.id, :user_id => user.id
    end

    it "should return true" do
      user.user_watch.count.should eq(0)
      user.should be_can_add_watch
    end

    it "should return false" do
      UserWatch.create :user_id => user.id, :url => 'google.com'
      user.should_not be_can_add_watch
    end
  end

  context "change plan" do

    it "should not change plan" do
      user.should_not be_should_change_plan
      user.change_plan.should be_nil

      UserWatch.create :url => 'google.com', :user_id => user.id

      user.should_not be_should_change_plan
      user.change_plan.should be_nil
    end

    it "should change plan" do
      plan = Plan.create :name => "name", :sites_count => 2, :price => 1.99
      UserWatch.create :url => 'google.com', :user_id => user.id
      UserWatch.create :url => 'mail.com', :user_id => user.id
      user.should be_should_change_plan
      user.change_plan.should be_true
      user.user_plan.plan.name.should eq(plan.name)
    end
  end
end
