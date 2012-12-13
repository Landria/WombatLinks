class ReTryMailJob < Resque::Job

  @queue = :ReMailLinkJob

  def self.perform
    links = UserLink.where(:is_send => false)
    links.each do |link|
      WombatMailer.send_link(link).deliver
      link.update_attribute(:is_send, true)
      sleep 15
    end
  rescue
  end

  def queue_job
    Resque.enqueue(ReMailLinkJob)
  end
end
