# encoding: utf-8
require 'spec_helper'

describe User do
  let(:user) { create :user }
  let(:promo) { create :active_promo }
  let(:not_active_promo) { create :not_active_promo }

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
      Plan.create :name => "name", :sites_count => 2, :price => 1.99

      user.should_not be_should_change_plan
      user.change_plan.should be_nil

      UserWatch.create :url => 'google.com', :user_id => user.id

      user.should_not be_should_change_plan
      user.change_plan.should be_nil
    end

    it "should change plan" do
      plan = Plan.create :name => "name", :sites_count => 3, :price => 1.99
      UserWatch.create :url => 'google.com', :user_id => user.id
      UserWatch.create :url => 'mail.com', :user_id => user.id

      Plan.get_suitable(user.user_watch.count).id.should eq(plan.id)

      user.should be_should_change_plan
      user.should be_should_change_plan_paid_upto plan

      user.change_plan.should be_true
      user.user_watch.delete_all
      user.user_watch.count.should eq(0)
      # разобраться с этим, почему не меняется план фактически
      #user2 = User.find(user.id)
      #user2.should be_should_change_plan
      #user2.change_plan.should be_true
    end

  end

  context "should change plan paid upto" do
     let(:plan) {Plan.create :name => "name", :sites_count => 3, :price => 1.99}

    it "should return true" do
       user.should be_should_change_plan_paid_upto plan
    end

    it "should return false if user_promo is active" do
      promo.link_user user.id
      user.should_not be_should_change_plan_paid_upto plan
    end

    it "should return true if user_promo is not active" do
      user.user_promo.delete_all
      not_active_promo.link_user user.id
      user.should be_should_change_plan_paid_upto plan
    end
  end

  it "should return mailing list status" do
    user.should_not be_mailing_list_cancelled "rates"
    CancelMailingList.change_status user.id, "rates"
    user.should be_mailing_list_cancelled "rates"

    user.should_not be_mailing_list_cancelled "monitor"
    CancelMailingList.change_status user.id, "monitor"
    user.should be_mailing_list_cancelled "monitor"

    user.should_not be_mailing_list_cancelled "monit"
    CancelMailingList.change_status user.id, "monit"
    user.should_not be_mailing_list_cancelled "monit"
  end


  context "lock  user" do
    it "should lock user" do
      link =  UserLink.new :user_id => user.id, :email => user.email, :link_url => 'http://google.com'
      link.save
      link.update_attribute(:is_spam, true)
      user.is_spammer?.should be_true
      user.check_lock
      user.is_locked.should be_true
    end

    it "should not lock user" do
      user.is_spammer?.should be_false
      user.check_lock
      user.is_locked.should be_false
    end
  end
end
