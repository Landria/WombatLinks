class LinkJob < Resque::Job

  @queue = :LinkJob
  
  def self.perform(link_id)
    require 'net/http'

    link = Link.find(link_id)
    data = false
    title_regexp = /<title>(\n?.*\n?)<\/title>/
    description_regexp = /meta.*description.*content=[",'](.*)[",']/

    response = Net::HTTP.get_response(URI.parse(URI.encode(link.link)))
    if response.is_a? Net::HTTPOK
      data = {"title" => response.body.scan(title_regexp)[0].to_s, "description" => response.body.scan(description_regexp)[0].to_s}
    end

    if(data != false)
      if(link.title.to_s.blank?)
        link.update_attribute(:title, data["title"])
      end
      if(link.description.to_s.blank?)
        link.update_attribute(:description , data["description"])
      end
    end    
  end

end
