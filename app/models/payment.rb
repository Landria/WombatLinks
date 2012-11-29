require "ip_addr"

class Payment < ActiveRecord::Base

  MIN_AMOUNT = Plan.get_min_plan_price

  attr_accessible :amount, :is_completed, :tool, :user_id
  attr_protected :payer_id, :is_completed, :ip

  validates :user_id, :presence => true
  validates :amount, :presence => true
  validates :amount, :numericality => { :greater_than_or_equal_to => MIN_AMOUNT }, :if => "!amount.blank?"

  self.per_page = 5

  def order_id
    self.id
  end

  def ip= ip
    super IpAddr.to_int(ip)
  end

  def complete payer_id
    self.update_attribute(:is_completed, true)
    self.update_attribute(:payer_id, payer_id)
  end

  def amount_with_cents
    (self.amount * 100).to_i
  end

  def self.find_for_user user_id, page
    self.where(:user_id => user_id).order('created_at DESC').paginate(:page => page)
  end

  def self.sum_of_completed_for_user user_id
    self.where('user_id = ? AND is_completed = true', user_id).sum(:amount)
  end
end
