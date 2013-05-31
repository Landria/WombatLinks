class MailLinkJob < Resque::Job

  @queue = :MailJob

  def self.perform id
    user_link = UserLink.find(id)
    sleep 10
    WombatMailer.send_link(id).deliver
    user_link.update_attribute(:is_send, true)
  #rescue
  end
end
