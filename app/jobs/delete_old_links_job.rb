class DeleteOldLinksJob < Resque::Job

  @queue = :DeleteOldLinksJob

  def self.perform
    period = Settings.anonymous_links_storage_period.to_i
    links = UserLink.where(:user_id => nil).where(["created_at < ?", period.months.ago]).order('created_at ASC')
    links.each do |link|
      link.destroy
    end
  end

  def queue_job
    Resque.enqueue(DeleteOldLinksJob)
  end
end
