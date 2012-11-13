class User < ActiveRecord::Base
  has_many :user_link, :dependent => :destroy
  has_many :unlock_request, :dependent => :destroy
  has_many :user_watch, :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :remember_me
  attr_protected :is_locked

  ROLES = %w[admin guest user]

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

  def set_lock
    if self.user_link.where(:is_spam == true).count > Settings.spam.max_spam_links_count
      self.is_locked = true
      self.save
    end

  end

  def set_unlock
    begin
      self.is_locked = false
      self.save
      self.link.where(:is_spam == true).each do |link|
        link.is_spam = false
        link.save
      end
    rescue
    end
  end

  def can_add_watch?
    true
  end

  def sites
    self.user_watch
  end
end
