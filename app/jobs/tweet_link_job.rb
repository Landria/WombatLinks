class TweetLinkJob < Resque::Job

  @queue = :TweetLinkJob

  def self.perform(id)
    link = Link.find(id)
    title = "New Wombat Link:"
    message = ''

    begin
      short_url = link.get_shortened_url

      if !link.title.to_s.blank?
      title =  link.title
      else if !link.description.to_s.blank?
          title = link.description
        end
      end

      title = title.truncate(60, :omission => '&hellip;', :separator => ' ')

      message = title + " " + short_url +" #WombatLinks"
      Twitter.update(message)
    rescue RuntimeError => error
      puts "Twitter error"
      puts error.inspect

      if(!message.to_s.blank?)
       tweet = Tweet.new(:message => message)
       tweet.save
      end
    end
  end
end
