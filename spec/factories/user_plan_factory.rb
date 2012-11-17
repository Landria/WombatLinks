# encoding: utf-8

FactoryGirl.define do
  factory :user_plan do
    paid_upto 5.days.ago
    association :plan, factory: :plan_free
  end
end
