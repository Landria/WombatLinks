class DeleteOldLinksJob < Resque::Job

  @queue = :DeleteJob

  def self.perform
    period = Settings.anonymous_links_live_period.to_i
    links = Link.where(:is_private => false, :user_id => nil).where(["created_at < ?", period.months.ago]).order('created_at ASC')
    links.each do |link|
      link.destroy
    end
  end

  def queue_job
    Resque.enqueue(TweetJob)
  end
end
