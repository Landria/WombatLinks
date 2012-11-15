# encoding: utf-8
require 'spec_helper'

describe Plan do
  let(:name) { "first"}

  it "should be free" do
    plan = described_class.new :name => name, :price => 0, :sites_count => 1
    plan.should be_valid
    plan.price.to_f.should eq(0)
    plan.should be_free
  end

  it "should not be free" do
    plan = described_class.new :name => name, :price => 1.99, :sites_count => 1
    plan.should be_valid
    plan.price.to_f.should_not eq(0)
    plan.should_not be_free
  end

  it "should not be valid" do
    plan = described_class.new :name => name, :price => 1.99
    plan.should_not be_valid

    plan = described_class.new :sites_count => 2, :price => 1.99
    plan.should_not be_valid

    plan = described_class.new :sites_count => 2, :name => name
    plan.should_not be_valid
  end

  it "should return free plan" do
    described_class.create :name => 'name1', :price => 0, :sites_count => 1
    described_class.create :name => 'name2', :price => 1.99, :sites_count => 3

    described_class.get_free.name.should eq('name1')
  end

  it "should return nil if free plan not exists" do
    described_class.create :name => 'name1', :price => 2.99, :sites_count => 5
    described_class.create :name => 'name2', :price => 1.99, :sites_count => 3

    described_class.get_free.should be_nil
  end

  it "should return free plan via get_suitable method" do
    described_class.create :name => 'name1', :price => 0, :sites_count => 1
    described_class.create :name => 'name2', :price => 1.99, :sites_count => 3

    described_class.get_suitable.name.should eq('name1')
  end

  it "should return first plan via get_suitable method if free plan not exists" do
    described_class.create :name => 'name1', :price => 1.99, :sites_count => 3
    described_class.create :name => 'name2', :price => 2.99, :sites_count => 5

    described_class.get_suitable.name.should eq('name1')
  end

end
