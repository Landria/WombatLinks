class User < ActiveRecord::Base
  has_many :user_link, :dependent => :nullify
  has_many :unlock_request, :dependent => :destroy
  has_many :user_watch, :dependent => :destroy
  has_one :user_plan, :dependent => :destroy
  has_many :user_promo, :dependent => :destroy
  has_many :domain, :through => :user_watch
  has_many :payments, :dependent => :destroy
  has_many :cancel_mailing_lists, :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :remember_me
  attr_protected :is_locked

  after_create :set_user_accounts

  def count_links private=nil, spam=nil
    links = UserLink.where(:user_id => self.id)
    links = links.where(:is_private => private) if !private.nil?
    links = links.where(:is_spam => spam) if !spam.nil?
    links.count
  end

  def user_links_percent
    if UserLink.all.count > 0
      system_links = UserLink.all.count
    else
      system_links = 1
    end

    user_links = UserLink.where(:user_id => self.id).count

    ((user_links*100)/system_links).to_i
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def is_spammer?
    self.user_link.where(:is_spam => true).count > Settings.spam.max_spam_links_count
  end

  def set_lock
    update_attribute(:is_locked, true)
  end

  def check_lock
    if self.is_spammer?
      set_lock
    end
  end

  def set_unlock
    begin
      update_attribute(:is_locked, false)
      self.user_link.where(:is_spam == true).each do |link|
        link.is_spam = false
        link.save
      end
      if request = self.unlock_request.where(:status => 'new').last
        request.accept!
      end
      true
    rescue
      false
    end
  end

  def can_add_watch?
    user_watch.count.to_i < Plan.get_max_sites_count
  end

  def sites
    self.user_watch
  end

  def stats_accessible?
    return self.user_plan.active? if self.user_plan
    false
  end

  def change_plan
    begin
      plan = Plan.get_suitable user_watch.count
      self.user_plan.change_to plan.id, should_change_plan_paid_upto?(plan), should_freeze? if should_change_plan?
    rescue
      false
    end
  end

  def should_change_plan?
    Plan.get_suitable(user_watch.count).sites_count != user_plan.plan.sites_count
  end

  # если есть активный promo у пользователя, период не пересчитывать
  def should_change_plan_paid_upto? plan
    if self.user_promo
      self.user_promo.each do |u_p|
        return false if u_p.active?
      end
    end
    return false if plan.free?
    true
  end

  # если есть активный promo у пользователя, freeze_days не пересчитывать
  def should_freeze?
    if self.user_promo
      self.user_promo.each do |u_p|
        return false if u_p.active?
      end
    end
    return false if user_plan.free?
    true
  end

  def complete_payment payment_id, payer_id
    payment = Payment.find(payment_id)
    payment.complete payer_id
    user_plan.recount_paid_upto payment_id
  rescue
    false
  end

  def can_access_payment?
    Plan.get_min_plan
  end

  def current_payment ip
    Payment.where('user_id = ? AND is_completed = false AND ip = ?', self.id, IpAddr.str2int(ip)).order('created_at DESC').first
  rescue
    nil
  end

  def total_payments
     Payment.sum_of_completed_for_user self.id
  end

  def get_payments page
    Payment.find_for_user self.id, page
  end

  def mailing_list_cancelled? type
    return true if cancel_mailing_lists.where(:list_type => type).first
    false
  end

  private
  def set_user_accounts
    Plan.set_new_user self.id
  end
end
