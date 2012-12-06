class UnlockRequest < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :message
  attr_protected :status

  def is_new?
    self.status == 'new'
  end

  def is_declined?
    self.status == 'declined'
  end

  def is_accepted?
    self.status == 'accepted'
  end

  def accept!
    self.status = 'accepted'
    self.save
    WombatMailer.send_unlock_notification(self.user_id, I18n.locale).deliver
  end

  def decline!
    self.status = 'declined'
    self.save
  end
end