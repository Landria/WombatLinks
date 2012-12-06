class Messages < ActiveRecord::Base
  attr_accessible :text, :subject, :user_id, :email_from

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email_from, presence: true
  validates :email_from,
            :format => {:with => EMAIL_REGEXP},
            :if => "!email_from.blank?"
  validates :subject, presence: true
  validates :text, presence: true

  after_create :email_to_admin

  private
  def email_to_admin
    WombatMailer.send_email_to_admin(self).deliver
  end

end
