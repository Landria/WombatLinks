class UnlockRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :message

  def status
    read_attribute(:status).to_s
  end

  def status= (value)
    write_attribute(:status, value.to_sym)
  end

  def is_new?
    self.status == 'new'
  end

  def is_declined?
    self.status == 'declined'
  end

  def is_accepted?
    self.status == 'accepted'
  end
end
