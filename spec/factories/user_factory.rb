# encoding: utf-8

FactoryGirl.define do
  factory :user do
    email "underveil@yahoo.com"
    password 447787
    is_locked false
    role 'user'

  end
end
