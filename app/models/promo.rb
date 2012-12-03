require 'digest/md5'
class Promo < ActiveRecord::Base
  attr_accessible :active_upto, :name, :period

  validates_presence_of :period
  validates_presence_of :active_upto
  validates :period, :numericality => { :only_integer => true, :greater_than => 0 }

  before_create :set_name

  def self.get_current
    self.where("active_upto > ?", Time.now).last
  end

  def active?
    self.active_upto.to_time > Time.now
  end

  def link_user user_id
    UserPromo.create user_id: user_id, promo_code: self.name
  rescue
  end

  private
  def set_name
    hash = Digest::MD5.hexdigest "WombatLinks" + self.inspect + Time.now.to_s
    self.name =  "WombatLinksPromo-" + hash
  end
end
