class User < ActiveRecord::Base
  has_many :link, :dependent => :destroy
  has_many :unlock_request, :dependent => :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_protected :is_locked

  ROLES = %w[admin guest user]

  def count_links private
    if (private)
      Link.where(:user_id => self.id, :is_private => true).count
    else
      Link.where(:user_id => self.id).count
    end
  end

  def user_links_percent
    system_links = Link.all.count
    user_links = Link.where(:user_id => self.id).count

    (user_links*100)/system_links
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def set_lock
    if self.link.where(:is_spam == true).count > Settings.spam.max_spam_links_count
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
end
