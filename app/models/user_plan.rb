class UserPlan < ActiveRecord::Base
  attr_accessible :paid_upto, :plan_id, :user_id

  belongs_to :user
  belongs_to :plan

  def new_paid_upto plan_id
    if freeze_days > 0
      upto = Time.now + freeze_days.days
      self.update_attribute(:freeze_days, 0)
    else
      upto = Time.now + ((self.plan.price / Plan.find(plan_id).price) * days_remain).days
    end
    return upto
  rescue
    self.paid_upto.to_time
  end

  # use when payments received
  def recount_paid_upto payment_id
    payment = Payment.find(payment_id)
    new_date = self.paid_upto.to_time + ((payment.amount.to_f / self.plan.price_per_day).floor + 1).days
    self.update_attribute(:paid_upto, new_date)
  rescue
    false
  end

  # use when promo activated
  def recount_paid_upto_via_promo promo_id
    new_date = self.paid_upto.to_time + Promo.find(promo_id).period.to_i.months
    self.freeze_days = days_remain if !plan.free?
    self.update_attribute(:paid_upto, new_date)
  rescue
    false
  end

  def days_remain
    paid_upto.to_date - Date.today
  end

  def active?
    self.paid_upto.to_date > Date.today || self.free?
  end

  def change_to plan_id, change_paid_upto = false

    freeze  =  days_remain

    if change_paid_upto
      self.paid_upto = new_paid_upto(plan_id)
    end

    self.plan_id = plan_id

    if self.free? and freeze
      self.freeze_days = freeze
    end

    self.save
  end

  def free?
    plan.free?
  end
end
