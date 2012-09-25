class LockedUser < ActiveRecord::Base

  def self.lock user_id
    if ! self.find_by_user_id user_id
      self.new(:user_id => user_id).save
    end
  end
end
