# encoding: utf-8

FactoryGirl.define do
  factory :active_promo, :class => Promo do
    period 2
    active_upto (Time.now + 2.months)
  end

  factory :not_active_promo, :class => Promo do
    period 2
    active_upto (Time.now - 2.days)
  end
end
