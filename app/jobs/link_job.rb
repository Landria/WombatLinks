require 'net/http'
require 'htmlentities'

class LinkJob < Resque::Job

  @queue = :LinkJob

  TITLE_REGEXP = /<title>[\n?]*[\s]*[\["]*(.+)["\]]*[\s]*[\n?]*<\/title>/
  DESCRIPTION_REGEXP = /meta.*description.*content=[",'](.*)[",']/

  def self.perform(id)
    begin
      user_link = UserLink.find(id)
      link = Link.find(user_link.link_id)
      return 0 unless link

      data = !link.title.blank?

      if !data
        response = Net::HTTP.get_response(URI.parse(URI.encode(link.name)))
        content = response.body

        if response.is_a? Net::HTTPOK
          if (response.body.encoding.to_s == 'ASCII-8BIT')
            begin
              # Try it as UTF-8 directly
              cleaned = content.dup.force_encoding('UTF-8')
              unless cleaned.valid_encoding?
                # Some of it might be old Windows code page
                cleaned = content.encode('UTF-8', 'Windows-1251')
              end
              content = cleaned
            rescue EncodingError
              # Force it to UTF-8, throwing out invalid bits
              content.encode!('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
            end
          end

          title = HTMLEntities.new.decode(content.scan(TITLE_REGEXP)[0].to_s)
          title = link.clean_text title, 240

          description = HTMLEntities.new.decode(content.scan(DESCRIPTION_REGEXP)[0].to_s)
          description = link.clean_text description, 240

          data = {"title" => title,
                  "description" => description}
        end

      end

      if data
        link.update_attribute(:title, data["title"]) unless data['title'].blank?
        link.update_attribute(:description, data["description"]) unless data['description'].blank?
      end

    ensure
      Resque.enqueue(MailLinkJob, user_link)
      #Resque.enqueue(TweetLinkJob, user_link) unless user_link.is_private?
    end
  end

end
