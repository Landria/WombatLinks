class TweetJob < Resque::Job
  
  @queue = :TweetJob
  
  def self.perform
    tweets = Tweet.find(:all, :limit => 20)
    tweets.each do |t|
      begin
        Twitter.update(t.message)
        sleep(30)
      rescue RuntimeError => error
        puts error.inspect
      else
        t.destroy
      end
    end
  end

  def queue_job
    Resque.enqueue(TweetJob)
  end
end
