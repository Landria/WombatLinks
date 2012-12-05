# encoding: utf-8
require 'spec_helper'

describe Promo do
  let(:user) { create :user }

  it "should create Promo with name" do
    promo = described_class.new :period => 2, :active_upto => Time.now + 2.days
    promo.should be_valid
    promo.save.should eq(true)
    promo.name.should_not be_nil
  end

  it "should not be valid" do
    promo = described_class.new :period => 0, :active_upto => Time.now + 2.days
    promo.should_not be_valid
  end

  it "should not be active" do
    promo = described_class.create :period => 2, :active_upto => Time.now - 2.days
    promo.should_not be_active
  end

  it "should return current active promo" do
    promo = described_class.create :period => 2, :active_upto => Time.now + 2.days, :registration => true
    described_class.get_current.should_not be_nil
  end

  it "should return nil if no active promos" do
    promo = described_class.create :period => 1, :active_upto => Time.now - 2.days, :registration => true
    described_class.get_current.should be_nil
  end

  it "should create UserPromo" do
    promo = described_class.create :period => 2, :active_upto => Time.now + 2.days
    promo.should_not be_nil
    promo.link_user(user.id)
    user_promo = UserPromo.find_by_user_id user.id
    user_promo.should_not be_nil
  end

end
