class Link < ActiveRecord::Base
  has_many :user_link, :dependent => :destroy
  validates_presence_of :name
  validates :name,
            :format => {:with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix},
            :if => "!name.blank?"

  def self.get_link_id name
    self.find_or_create_by_name(:name => name).id
  end
end
