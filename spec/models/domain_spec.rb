# encoding: utf-8
require 'spec_helper'

describe Domain do

  it "should return domain from url" do
    described_class.get_domain_from_url("http://www.google.com").should eq("google.com")
    described_class.get_domain_from_url("http://google.com").should eq("google.com")
    described_class.get_domain_from_url("https://google.com").should eq("google.com")
    described_class.get_domain_from_url("http://google.com/").should eq("google.com")
    described_class.get_domain_from_url("http://google.com/sdsdfgs/sfg/").should eq("google.com")
    described_class.get_domain_from_url("google.com/sdsdfgs/").should eq("google.com")
  end

  it "should add domain" do
    domain = described_class.get_domain("http://www.google.com")
    domain.name.should eq("google.com")
    described_class.all.count.should eq(1)
  end

  it "should return url with protocol" do
    domain = described_class.check_url("google.com")
    domain.should eq("http://google.com")
  end
end
