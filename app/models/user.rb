class User < ActiveRecord::Base
  has_many :link, :dependent=>:destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = %w[admin guest user]

  def count_links private
    if (private)
      Link.where(:user_id =>self.id, :is_private => true).count
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
end
