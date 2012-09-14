class DeleteOldLinksJob < Resque::Job

  @queue = :DeleteJob

  def self.perform
    links = Link.where(:is_private => false, :user_id => nil).order('created_at ASC')

    links.each do |t|
      if(t.created_at < 2.months.ago)
      t.destroy
      end
    end
  end

  def queue_job
    Resque.enqueue(TweetJob)
  end
end
