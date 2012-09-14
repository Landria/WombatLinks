class Link < ActiveRecord::Base
  include PgSearch
  pg_search_scope :user_search,
                  :against => [:link, :email, :title, :description, :created_at],
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  belongs_to :user

  validates_presence_of :link, :email
  validates :link,
              :format => { :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix },
              :if => "!link.blank?"
  validates :email,
              :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
              :if => "!email.blank?"

  self.per_page = 10

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

  def self.search(all, user_id, page, search)

    if user_id.nil?
      links = self.where(:is_private => false)
    else
      if all
        links = self.where((:is_private == false) | (:user_id == user_id))
      else
        links = self.where(:user_id => user_id)
      end
    end

    if !search.blank?
      links = user_search(search.to_s)
    end

    links.order('created_at DESC').paginate(:page => page)
  end

  def user_link? user
    self.user_id == user.id
  end
end