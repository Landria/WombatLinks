# encoding: utf-8
require 'spec_helper'

describe UserPlan do
  let(:user) { create :user }
  let(:plan) { create :plan_free }
  let(:new_plan) { create :plan_paid }

  context "change plan" do
    it "should change plan" do
      user.user_plan.change_to new_plan.id, true
      user.user_plan.paid_upto.to_date.should eq(Date.today)
    end

    it "should change plan to free and should be active" do
      user_plan = user.user_plan
      user_plan.change_to new_plan.id
      user_plan.should_not be_active
      user_plan.change plan.id
      user_plan.should be_active
    end

    it "should change plan to free and should set freeze days" do
      user_plan = user.user_plan
      user_plan.change_to new_plan.id
      user_plan.update_attribute(:paid_upto, Date.today + 5.days)
      user_plan.change plan.id
      user_plan.freeze_days.should eq(5)
    end
  end

  context "new paid upto" do
    it "should return new paid upto" do
      user.user_plan.paid_upto.to_date.should eq(5.days.ago.to_date)
      user.user_plan.new_paid_upto(new_plan.id).to_date.should eq(Date.today)

      user.user_plan.change_to new_plan.id, true
      user.user_plan.update_attribute(:paid_upto, Date.today + 2.days)

      user.user_plan.change_to plan.id
      user.user_plan.freeze_days.should eq(2)

      user.user_plan.change_to new_plan.id, true

      user.user_plan.paid_upto.to_date.should eq(Date.today+ 2.days)
    end
  end
end
