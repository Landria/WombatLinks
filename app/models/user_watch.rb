# encoding: utf-8
class UserWatch < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain
  attr_accessible :user_id
  attr_accessor :url
  attr_protected :domain_id

  URL_REGEXP = /\A[A-Za-zА-ЯЁа-яё0-9]+([\-\.]{1}[A-Za-zА-ЯЁа-яё0-9]+)*\.[a-zA-ZА-ЯЁа-яё]{2,5}\Z/

  validates :url, :presence => true
  validates :url,
            :format => {:with => URL_REGEXP},
            :if => "!url.blank?"

  validates_with UserDomainUniquenessValidator, :if => "errors[:url].blank?"
  before_create :set_domain_id

  def self.accessible? url, user_id
    !self.where("domain_id = ? AND user_id != ?", Domain.get_domain_id(url), user_id.to_i).exists?
  end

  private

  def set_domain_id
    self.domain_id = Domain.get_domain_id(self.url)
  end

end
