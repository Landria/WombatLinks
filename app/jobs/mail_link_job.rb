class MailLinkJob < Resque::Job

  @queue = :MailLinkJob
  
  def self.perform(link_id)
    link = Link.find(link_id)
    WombatMailer.send_link(link).deliver
  end
end
