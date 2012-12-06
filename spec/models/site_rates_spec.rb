# encoding: utf-8
require 'spec_helper'

describe SiteRate do
  let(:user) { create :user }
  let(:email) { 'underveil2@yahoo.com' }
  let(:email2) { 'underveil22@yahoo.com' }
  let(:email3) { 'underveil22@yahoo.com' }
  let(:link_url) { 'http://link.info' }
  let(:link_url_2) { 'http://google.info' }
  let(:domain_name) { 'link.info' }

  context "recount rates" do

    it "should return total position" do
      link = UserLink.new :email => user.email, :link_url => link_url
      link.save

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.save

      link3 = UserLink.new :email => user.email, :link_url => link_url_2
      link3.save

      described_class.recount_all_rates
      domain = link.link.domain

      described_class.total_to_position(domain.site_rate.total).should eq(1)

      domain2 = link3.link.domain
      described_class.total_to_position(domain2.site_rate.total).should eq(2)
    end

    it "should recount rates" do
      link1 = UserLink.new :email => user.email, :link_url => link_url
      link1.save

      link2 = UserLink.new :email => user.email, :link_url => link_url_2
      link2.save

      described_class.recount_all_rates

      link1.link.domain.site_rate.total.should eq(1)
      link2.link.domain.site_rate.total.should eq(1)

      described_class.total_to_position(link1.link.domain.site_rate.total).should eq(1)
      described_class.total_to_position(link2.link.domain.site_rate.total).should eq(1)

      link3 = UserLink.new :email => email2, :user_id => user.id, :link_url => link_url_2
      link3.save

      described_class.recount_all_rates

      link1 = UserLink.find(link1.id)
      link2 = UserLink.find(link2.id)
      link1.link.domain.site_rate.position.should eq(2)
      link2.link.domain.site_rate.position.should eq(1)
      described_class.total_to_position(link3.link.domain.site_rate.total).should eq(1)

      link2.link.domain.site_rate.total.should eq(2)
      link1.link.domain.site_rate.total.should eq(1)
      described_class.total_to_position(link1.link.domain.site_rate.total).should eq(2)

    end

    it "should recount rates with duplicate user_links" do
      link1 = UserLink.new :email => user.email, :user_id => user.id, :link_url => link_url
      link1.save

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.save

      link3 = UserLink.new :email => user.email, :user_id => user.id, :link_url => link_url
      link3.save

      link4 = UserLink.new :email => email, :link_url => link_url_2
      link4.save

      described_class.recount_all_rates

      described_class.total_to_position(link1.link.domain.site_rate.total).should eq(1)
      described_class.total_to_position(link4.link.domain.site_rate.total).should eq(2)

      link1.link.domain.site_rate.total.should eq(2)
      link4.link.domain.site_rate.total.should eq(1)
    end

    it "should recount rates with previous periods data" do
      link1 = UserLink.new :email => user.email, :user_id => user.id, :link_url => link_url
      link1.save

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.save

      link1.update_attribute(:created_at, 8.days.ago)
      described_class.recount_all_rates

      link1.link.domain.site_rate.prev_week.should eq(1)
    end

  end

end
