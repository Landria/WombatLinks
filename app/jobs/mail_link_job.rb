class MailLinkJob < Resque::Job

  @queue = :MailJob

  def self.perform user_link_id
    link = UserLink.find(user_link_id)
    sleep 30
    WombatMailer.send_link(link).deliver
    link.update_attribute(:is_send, true)
  rescue
  end
end
