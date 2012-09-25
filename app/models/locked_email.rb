class LockedEmail < ActiveRecord::Base

  def self.lock email
    if ! self.find_by_email user_id
      self.new(:email => email).save
    end
  end
end
