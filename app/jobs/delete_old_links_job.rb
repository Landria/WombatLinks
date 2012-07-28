class DeleteOldLinksJob < Resque::Job

  @queue = :DeleteJob
  
  def self.perform
    links = Link.where(:is_private => false, :user_id => 'NULL').order('created_at ASC')

    links.each do |t|
      if(links.created_at < 7.days.ago)
      t.destroy
      end
    end
  end

  def queue_job
    Resque.enqueue(TweetJob)
  end
end
