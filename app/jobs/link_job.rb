class LinkJob < Resque::Job

  @queue = :LinkJob
  
  def self.perform(link_id)
    require 'net/http'
    require 'htmlentities'

    link = Link.find(link_id)
    data = false
    title_regexp = /<title>[\n?]*[\s]*[\["]*(.+)["\]]*[\s]*[\n?]*<\/title>/
    description_regexp = /meta.*description.*content=[",'](.*)[",']/

    response = Net::HTTP.get_response(URI.parse(URI.encode(link.link)))
    content = response.body

    if(response.body.encoding.to_s == 'ASCII-8BIT')
      begin
      # Try it as UTF-8 directly
      cleaned = content.dup.force_encoding('UTF-8')
      unless cleaned.valid_encoding?
        # Some of it might be old Windows code page
        cleaned = content.encode( 'UTF-8', 'Windows-1251' )
      end
      content = cleaned
    rescue EncodingError
      # Force it to UTF-8, throwing out invalid bits
      content.encode!( 'UTF-8', :invalid => :replace, :undef => :replace, :replace => '' )
    end
    end

    if response.is_a? Net::HTTPOK
      data = {"title" => HTMLEntities.new.decode(content.scan(title_regexp)[0].to_s),
        "description" => HTMLEntities.new.decode(content.scan(description_regexp)[0].to_s)}
    end

    if(data != false)
      if(link.title.blank? && !data['title'].blank?)
        title = data["title"]
        title['["'] = ''
        title['"]'] = ''
        title.truncate(240, :omission => '&hellip;', :separator => ' ')
        link.update_attribute(:title, title)
      end
      if(link.description.blank? && !data['description'].blank?)
        description = data["description"]
        description['["'] = ''
        description['"]'] = ''
        description.truncate(240, :omission => '&hellip;', :separator => ' ')
        link.update_attribute(:description , description)
      end
    end
  end

end
