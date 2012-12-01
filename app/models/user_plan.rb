class UserPlan < ActiveRecord::Base
  attr_accessible :paid_upto, :plan_id, :user_id

  belongs_to :user
  belongs_to :plan

  def new_paid_upto plan_id
    begin
      if self.user.should_change_plan_paid_upto?
        promo = Promo.get_current
        if promo
          promo.link_user self.user_id if UserPromo.where(:promo_id => promo.id).exists?
          Time.now + promo.period.months
        else
          Time.now + ((self.plan.price / Plan.find(plan_id).price) * days_remain).days
        end
      end
    rescue
      self.paid_upto.to_time
    end
  end

  # use when payments received
  def recount_paid_upto payment_id
    payment = Payment.find(payment_id)
    new_date = self.paid_upto.to_time + ((payment.amount.to_f / self.plan.price_per_day).floor + 1).days
    self.update_attribute(:paid_upto, new_date)
  rescue
    fasle
  end

  def days_remain
    paid_upto.to_date - Date.today
  end

  def active?
    self.paid_upto.to_date > Date.today || self.plan.free?
  end

  def change plan_id
    self.plan_id = plan_id
    self.save
  end

  def change_with_paid_upto plan_id
    self.plan_id = plan_id
    self.paid_upto = new_paid_upto(plan_id)
    self.save
  end

  def free?
    plan.free?
  end
end
