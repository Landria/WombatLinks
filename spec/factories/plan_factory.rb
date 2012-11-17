# encoding: utf-8

FactoryGirl.define do
  factory :plan_free, :class => Plan do
    name "plan_free_name"
    sites_count 1
    price 0
  end

  factory :plan_paid, :class => Plan do
    name "plan_paid_name"
    sites_count 2
    price 1.99
  end
end
