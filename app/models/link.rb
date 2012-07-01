class Link < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :link, :email
  validates :link,
              :format => { :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix },
              :if => "!link.blank?"
  validates :email,
              :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
              :if => "!email.blank?"
              
  def get_shortened_url()
    url = self.link
    begin
    authorize = UrlShortener::Authorize.new 'landria', 'R_de421b9f20e1012c66b13504051ce7c8'
    client = UrlShortener::Client.new authorize
    shorten = client.shorten(self.link + "?time= "+ Time.now.to_s)
    rescue RuntimeError => error
      puts "BitLy error"
      puts error.inspect
    else
      url = shorten.urls.to_s
    ensure
      return url
    end
  end
end