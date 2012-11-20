class MailLinkJob < Resque::Job

  @queue = :MailLinkJob

  def self.perform(user_link_id, locale)
    sleep 30
    link = UserLink.find(user_link_id)
    if WombatMailer.send_link(link, locale).deliver
      link.update_attribute(:is_send, true)
    end
  end
end
