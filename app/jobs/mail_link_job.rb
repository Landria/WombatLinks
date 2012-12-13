class MailLinkJob < Resque::Job

  @queue = :MailLinkJob

  def self.perform(user_link_id, locale)
    link = UserLink.find(user_link_id)
    WombatMailer.send_link(link, locale).deliver
    link.update_attribute(:is_send, true)
  rescue
  end
end
