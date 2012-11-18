class UserPromo < ActiveRecord::Base
  attr_accessible :promo_id, :user_id
  belongs_to :user
  belongs_to :promo

  def self.add user_id, promo_id
    self.create :user_id => user_id, :promo_id => promo_id
  end

  def self.get_active_user_promo user_id, promo_id
    user_promos = where(:user_id => user_id, :promo_id => promo_id)

  end
end
