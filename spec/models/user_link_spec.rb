# encoding: utf-8
require 'spec_helper'

describe UserLink do
  let(:user) { create :user }
  let(:email) { 'underveil@yahoo.com' }
  let(:email_2) { 'underveil2@yahoo.com' }
  let(:link_url) { 'http://link.info' }
  let(:link_url_2) { 'http://link.info/page=2' }
  let(:domain) { stub name: 'link.info' }

  let(:email_wrong) { 'underveil@.com' }
  let(:link_name_wrong) { 'link' }

  context "create user link" do
    it "should create user_link" do
      user_link = described_class.new :email => email, :link_url => link_url
      user_link.should be_valid
      user_link.save.should eq true
      user_link.link_hash.should_not be_nil
      user_link.link.domain_id.should_not be_nil
    end

    it "should create private user_link" do
      user_link = described_class.new :email => email, :link_url => link_url, :is_private => true
      user_link.should be_valid
      user_link.save.should eq true
      user_link.link_hash.should_not be_nil
      user_link.link.domain_id.should_not be_nil
    end

    it "should not create user_link" do
      user_link = described_class.new :email => email_wrong, :link_url => link_url
      user_link.should_not be_valid
      user_link.save.should eq false

      user_link = described_class.new :email => email, :link_url => link_name_wrong
      user_link.should_not be_valid
      user_link.save.should eq false
    end
  end

  context "get links for domain" do
    it "should return [] if no link exists " do
      described_class.get_links_for_domain(domain.name).should be_empty
      user_link = described_class.new :email => email, :link_url => link_url
      user_link.save
      described_class.get_links_for_domain(domain.name).should_not be_empty
      user_link.update_attribute(:created_at, 3.months.ago)
      Domain.count.should eq(1)
      described_class.get_links_for_domain(domain.name).should be_empty
    end

    it "should return array of user links " do
      user_link = described_class.new :email => email, :link_url => link_url
      user_link.save
      links = described_class.get_links_for_domain(domain.name)
      links.should_not be_empty
      links.count.should eq(1)

      user_link = described_class.new :email => email, :link_url => link_url_2
      user_link.save

      links = described_class.get_links_for_domain(domain.name)
      links.should_not be_empty
      links.count.should eq(2)

    end
  end

  context "clear links" do
    it "should return cleared from duplicates links" do
      links = described_class.clear_duplicates described_class.all
      links.count.should eq(0)

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.save

      link1 = UserLink.new :email => email_2, :link_url => link_url
      link1.save

      links = described_class.clear_duplicates described_class.all
      links.count.should eq(2)

      link3 = UserLink.new :email => email, :link_url => link_url
      link3.save

      links = described_class.clear_duplicates described_class.all
      links.count.should eq(2)


      link4 = UserLink.new :email => email_2, :link_url => link_url
      link4.save

      links = described_class.clear_duplicates described_class.all
      links.count.should eq(2)

      link5 = UserLink.new :email => email, :user_id =>user.id, :link_url => link_url
      link5.save

      links = described_class.clear_duplicates described_class.all
      links.count.should eq(3)
    end

    it "should return cleared from spam links" do
      link1 = UserLink.new :email => email_2, :link_url => link_url
      link1.save

      link2 = UserLink.new :email => email, :link_url => link_url
      link2.save
      link2.update_attribute(:is_spam, true)
      described_class.all.count.should eq(2)

      links = described_class.clear_spam described_class.all
      links.count.should eq(1)
    end

    it "should return cleared from all links" do
      link1 = UserLink.new :email => email_2, :link_url => link_url
      link1.save

      link2 = UserLink.new :email => email, :link_url => link_url_2
      link2.save
      link2.update_attribute(:is_spam, true)

      link3 = UserLink.new :email => email_2, :link_url => link_url
      link3.save

      described_class.all.count.should eq(3)

      links = described_class.clear described_class.all
      links.count.should eq(1)

      link4 = UserLink.new :email => email, :link_url => link_url_2
      link4.save

      links = described_class.clear described_class.all
      links.count.should eq(2)
    end

    it "should delete only user_link" do
      user_link = described_class.new :email => email, :link_url => link_url
      user_link.should be_valid
      user_link.save.should eq true
      link = user_link.link
      user_link.destroy
      Link.find(link.id).should_not be_nil
    end
  end

end
