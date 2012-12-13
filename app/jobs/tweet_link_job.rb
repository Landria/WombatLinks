class TweetLinkJob < Resque::Job

  @queue = :TweetLinkJob

  def self.perform(id)
    link = UserLink.find(id)
    title = "New Wombat Link:"
    message = ''

    begin
      short_url = link.get_shortened_url
      title =  link.show_title !link.show_title.to_s.blank?
      title = link.show_description if link.show_title.to_s.blank? and !link.show_description.to_s.blank?
      title = title.truncate(60, :omission => '&hellip;', :separator => ' ')
      message = title + " " + short_url +" #WombatLinks"
      Twitter.update(message)
    rescue
      if(!message.to_s.blank?)
       tweet = Tweet.new(:message => message)
       tweet.save
      end
    end
  end
end