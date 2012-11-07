class MailLinkJob < Resque::Job

  @queue = :MailLinkJob

  def self.perform(user_link_id, locale)
    sleep 120
    link = UserLink.find(user_link_id)
    if WombatMailer.send_link(link, locale).deliver
      link.is_send = true
      link.save
    end
  end
end
