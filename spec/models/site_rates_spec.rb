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
      link.add

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.add

      link3 = UserLink.new :email => user.email, :link_url => link_url_2
      link3.add

      described_class.recount_all_rates
      domain = link.link.domain

      described_class.total_to_position(domain.site_rate.total).should eq(1)

      domain2 = link3.link.domain
      described_class.total_to_position(domain2.site_rate.total).should eq(2)
    end

    it "should recount rates" do
      link1 = UserLink.new :email => user.email, :link_url => link_url
      link1.add

      link2 = UserLink.new :email => user.email, :link_url => link_url_2
      link2.add

      described_class.recount_all_rates

      link1.link.domain.site_rate.total.should eq(1)
      link2.link.domain.site_rate.total.should eq(1)

      described_class.total_to_position(link1.link.domain.site_rate.total).should eq(1)
      described_class.total_to_position(link2.link.domain.site_rate.total).should eq(1)

      link3 = UserLink.new :email => email2, :user_id => user.id, :link_url => link_url_2
      link3.add

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
      link1.add

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.add

      link3 = UserLink.new :email => user.email, :user_id => user.id, :link_url => link_url
      link3.add

      link4 = UserLink.new :email => email, :link_url => link_url_2
      link4.add

      described_class.recount_all_rates

      described_class.total_to_position(link1.link.domain.site_rate.total).should eq(1)
      described_class.total_to_position(link4.link.domain.site_rate.total).should eq(2)

      link1.link.domain.site_rate.total.should eq(2)
      link4.link.domain.site_rate.total.should eq(1)
    end

  end

end
