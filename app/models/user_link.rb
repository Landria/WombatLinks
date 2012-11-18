require 'digest/md5'
class UserLink < ActiveRecord::Base
  include PgSearch
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix

  pg_search_scope :user_search,
                  :against => [:link, :email, :title, :description],
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  belongs_to :user, :dependent => :delete
  belongs_to :link, :dependent => :delete

  validates_presence_of :email
  validates :email,
            :format => {:with => EMAIL_REGEXP},
            :if => "!email.blank?"
  validates_presence_of :link_url
  validates :link_url,
            :format => {:with => URL_REGEXP},
            :if => "!link_url.blank?"

  attr_accessible :email, :title, :description, :is_private
  attr_protected :link_hash, :is_spam, :link_id
  attr_accessor :link_url

  self.per_page = 10

  def add
    if self.valid?
      set_link if !self.link_id
      set_link_hash if !self.link_hash
      self.save
    else
      false
    end
  end

  def url
    self.link.name
  end

  def get_shortened_url()
    url = self.link
    begin
      #authorize = UrlShortener::Authorize.new 'landria', 'R_de421b9f20e1012c66b13504051ce7c8'
      authorize = UrlShortener::Authorize.new Settings.bitly.login, Settings.bitly.api_key
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

  def show_title
    if !self.title.blank?
      self.title
    else
      self.link.title
    end
  end

  def show_description
    if !self.description.blank?
      self.description
    else
      self.link.description
    end
  end

  def self.search(all, user_id, page, search)

    if user_id.nil?
      links = self.where(:is_private => false, :is_spam => false)
    else
      if all
        #links = self.where(((:is_private == false) && (:is_spam == false)) | (:user_id == user_id))
        links = self.where("is_private = ? AND is_spam = ? OR user_id = ?", false, false, user_id)
      else
        links = self.where(:user_id => user_id)
      end
    end

    if !search.blank?
      links = links.user_search(search.to_s)
    end

    links.order('created_at DESC').paginate(:page => page)
  end

  def user_link? user
    self.user_id == user.id
  end

  def clean_text text, truncate_i
    text['["'] = ''
    text['"]'] = ''
    text.truncate(truncate_i, :omission => '&hellip;', :separator => ' ')
  end

  private
  def set_link_hash
    hash_string = "link_hash=" + self.inspect + Time.now.to_s
    hash = Digest::MD5.hexdigest hash_string
    self.link_hash = hash
  end

  def set_link
    self.link_id = Link.get_link_id self.link_url.to_s
  end

end