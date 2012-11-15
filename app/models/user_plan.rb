class UserPlan < ActiveRecord::Base
  attr_accessible :paid_upto, :plan_id, :user_id

  belongs_to :user
  belongs_to :plan

  def reset_paid_up_to

  end

  def get_days_remain
    self.reset_paid_up_to.to_date - Date.today
  end

  def active?
    self.reset_paid_up_to.to_date > Date.today
  end

  def self.set_new_user user_id
    begin
      promo = Promo.get_current
      if promo
        period = promo.period
        promo.link_with_user user_id
      else
        period = Settings.registration.prepaid_period.to_i
      end
      self.create :user_id => user_id, :plan_id => Plan.get_suitable.id, :paid_upto => Date.today + period.months
    rescue
    end
  end
end
