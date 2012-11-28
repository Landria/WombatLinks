require "ip_addr"

class Payment < ActiveRecord::Base
  attr_accessible :amount, :is_completed, :tool, :user_id
  attr_protected :token, :payer_id, :is_completed, :ip

  validates :user_id, :presence => true
  validates :amount, :presence => true, :numericality => true

  def order_id
    self.id
  end

  def ip= ip
    super IpAddr.to_int(ip)
  end

  def complete
    self.update_attribute(:is_completed, true)
  end

  def amount_with_cents
    (self.amount * 100).to_i
  end
end
