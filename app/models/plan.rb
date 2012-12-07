class Plan < ActiveRecord::Base
  attr_accessible :name, :price, :sites_count

  validates :name, :presence => true
  validates :price, :presence => true
  validates :sites_count, :presence => true

  def free?
    self.price.to_f == 0
  end

  def self.get_free
    self.where(:price => 0).first
  end

  def self.get_first_suitable
    get_free || self.order("sites_count ASC").first
  end

  def self.get_suitable count
    where("sites_count >= ?", count).order("sites_count ASC").first if count > -1
  end

  def self.get_max_plan
    order("sites_count DESC").first
  end

  def self.get_min_plan
    where('price > 0').order("sites_count ASC").first
  end

  def self.get_min_plan_price
    plan = get_min_plan
    return plan.price if plan
    1
  end

  def self.get_max_sites_count
    get_max_plan.sites_count.to_i #if get_max_plan
  end

  def self.set_new_user user_id
      promo = Promo.get_current
      if promo
        period = promo.period
        promo.link_user user_id
      else
        period = Settings.registration.prepaid_period.to_i
      end
     UserPlan.create :user_id => user_id, :plan_id => get_first_suitable.id, :paid_upto => Date.today + period.months
  end

  def price_per_day
    price = self.price.to_f
    price = Plan.get_min_plan_price.to_f if self.free?
    price / 30
  end

end
