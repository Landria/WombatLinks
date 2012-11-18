# encoding: utf-8
require 'spec_helper'

describe UserPlan do
  let(:user) { create :user }
  let(:plan) { create :plan_free }
  let(:new_plan) { create :plan_paid }

  context "change plan" do
    it "should change plan" do
      user.user_plan.change new_plan.id
      user.user_plan.paid_upto.to_date.should eq(Date.today)
    end

    it "should change plan with promo" do
      promo = Promo.create :period => 2, :active_upto => Time.now + 2.days
      user_plan = user.user_plan
      user_plan.change(new_plan.id).should be_true
      user_plan.paid_upto.to_date.should eq(Date.today + promo.period.to_i.months)
    end

    it "should change plan to free and should be active" do
      user_plan = user.user_plan
      user_plan.change new_plan.id
      user_plan.should_not be_active
      user_plan.change plan.id
      user_plan.should be_active
    end
  end

  context "new paid upto" do
    it "should return new paid upto" do
      user.user_plan.paid_upto.to_date.should eq(5.days.ago.to_date)
      user.user_plan.new_paid_upto(new_plan.id).to_date.should eq(Date.today)

      promo = Promo.create :period => 2, :active_upto => Time.now + 2.days
      user.user_plan.new_paid_upto(new_plan.id).to_date.should eq(Date.today + promo.period.to_i.months)
    end
  end
end
