class ReTryMailJob < Resque::Job

  @queue = :ReMailLinkJob

  def self.perform
    links = Link.where(:is_send => false)
    links.each do |link|
      if WombatMailer.send_link(link).deliver
        link.is_send = true
        link.save
        sleep 15
      end
    end
  end

  def queue_job
    Resque.enqueue(ReMailLinkJob)
  end
end
