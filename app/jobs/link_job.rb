require 'net/http'
require 'htmlentities'

class LinkJob < Resque::Job

  @queue = :LinkJob

  def self.perform(link_id)
    link = Link.find(link_id)
    return 0 unless link

    data = false

    if !link.title.blank?
      return 0
    end

    if !data
      title_regexp = /<title>[\n?]*[\s]*[\["]*(.+)["\]]*[\s]*[\n?]*<\/title>/
      description_regexp = /meta.*description.*content=[",'](.*)[",']/

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

        title =  HTMLEntities.new.decode(content.scan(title_regexp)[0].to_s)
        title = link.clean_text title, 240

        description = HTMLEntities.new.decode(content.scan(description_regexp)[0].to_s)
        description = link.clean_text description, 240

        data = {"title" => title,
                "description" => description}
      end

    end

    if data
      link.update_attribute(:title, data["title"]) if !data['title'].blank?
      link.update_attribute(:description, data["description"]) if !data['description'].blank?
    end

  end

end
