class MailLinkJob < Resque::Job

  @queue = :MailLinkJob

  def self.perform(link_id)
    link = Link.find(link_id)
    # сделать 2 минутную задержку перед отправкой ссылки на email
    WombatMailer.send_link(link).deliver
  end
end
