class UserPromo < ActiveRecord::Base
  belongs_to :user
  belongs_to :promo

  attr_accessible :user_id, :promo_code, :promo_id
  attr_accessor :promo_code

  validates_presence_of :user_id
  validates_presence_of :promo_code
  validates_presence_of :promo_id, :if => '!promo_code.blank?'
  validates :promo_id, :uniqueness => {:scope => :user_id}, :if => '!promo_id.nil?'

  before_validation :set_promo_id
  after_create :recount_plan_paid_upto

  def self.add user_id, promo_id
    self.create :user_id => user_id, :promo_id => promo_id
  end

  def self.get_active_user_promo user_id, promo_id
    user_promos = where(:user_id => user_id, :promo_id => promo_id)
  end

  def active?
    Date.today < (self.created_at.to_date + promo.period.to_i.months)
  end

  private

  def set_promo_id
    promo = Promo.find_by_name(self.promo_code) if !self.promo_code.blank?
    self.promo_id = promo.id if promo and promo.active?
  end

  def recount_plan_paid_upto
    User.find(self.user_id).user_plan.recount_paid_upto_via_promo self.promo_id
  rescue
    false
  end
end
