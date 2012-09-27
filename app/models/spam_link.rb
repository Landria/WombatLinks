class SpamLink < ActiveRecord::Base
  belongs_to :link

  def update_count
    self.update_attribute(:count, self.count+1)
  end
end
