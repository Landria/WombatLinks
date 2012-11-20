require 'addressable/uri'

class Domain < ActiveRecord::Base
  attr_accessible :name
  after_create :initialize_stats
  has_one :site_rate
  has_many :link
  has_many :user_link, :through => :link

  def self.get_domain_name_from_url url
    Addressable::URI.parse(self.check_url(url.downcase)).host.sub(/\Awww\./, '')
  end

  def self.get_domain_id url
    get_domain(url).id
  rescue
    nil
  end

  def self.get_domain url
    domain_name = self.get_domain_name_from_url url.downcase
    self.find_or_create_by_name(:name => domain_name)
  end

  private
  def self.check_url value
    uri = Addressable::URI.parse(value)
    value = "http://" + value if !["http","https","ftp"].include?(uri.scheme)
    value
  end

  def initialize_stats
    SiteRate.create :domain_id => self.id
  end
end
