class TweetJob
 @queue = :TweetJob

 def self.perform
    puts "20 tweets are sent"
 end
end