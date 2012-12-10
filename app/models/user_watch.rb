# encoding: utf-8
class UserWatch < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain

  attr_accessible :user_id
  attr_accessor :url
  attr_protected :domain_id

  URL_REGEXP = /\A[A-Za-zА-ЯЁа-яё0-9]+([\-\.]{1}[A-Za-zА-ЯЁа-яё0-9]+)*\.[a-zA-ZА-ЯЁа-яё]{2,5}\Z/

  validates :url, :presence => true
  validates :user_id, :presence => true
  validates :url,
            :format => {:with => URL_REGEXP},
            :if => "!url.blank?"

  validates :domain_id, :uniqueness => {:scope => :user_id}
  before_validation :set_domain_id

  private

  def set_domain_id
    self.domain_id = Domain.get_domain_id(self.url) if !self.url.blank?
  end

  def change_plan
    user = User.find(self.user_id)
    return false if !user
    user.user_plan.change_to Plan.get_suitable user.user_watch.count
  end

end
