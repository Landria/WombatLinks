class MailLinkJob < Resque::Job

  @queue = :MailLinkJob

  def self.perform(link_id, locale)
    sleep 120
    link = Link.find(link_id)
    if WombatMailer.send_link(link, locale).deliver
      link.is_send = true
      link.save
    end
  end
end
