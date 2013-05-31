class MailLinkJob < Resque::Job

  @queue = :MailJob

  def self.perform user_link
    sleep 30
    WombatMailer.send_link(user_link).deliver
    user_link.update_attribute(:is_send, true)
  rescue
  end
end
