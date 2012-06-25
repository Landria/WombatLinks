require 'test_helper'
require 'tweet_job'

class TweetJobTest < ActiveSupport::TestCase
  
  def setup
    Resque.reset!
  end
  
  def test_job_queued
    TweetJob::new.queue_job
    assert_queued(TweetJob) # assert that TweetJob was queued in the :low queue
  end
  
  def test_job_runs 
    TweetJob::new.queue_job
    Resque.run!
    assert_equal 1, Resque.queue(:TweetJob).length
  end

  def test_job_scheduled
   Resque.enqueue_in(60, TweetJob) # enqueues TweetJob in 60 seconds
   Resque.run!
   assert_queued_in(60, TweetJob) # will pass
  end

end

