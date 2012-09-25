class SpamLink < ActiveRecord::Base

  def update_count
    self.update_attribute(:count, self.count+1)
  end
end
