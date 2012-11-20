class Link < ActiveRecord::Base
  has_many :user_link, :dependent => :destroy
  belongs_to :domain

  validates_presence_of :name
  validates :name,
            :format => {:with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix},
            :if => "!name.blank?"

  after_create :set_domain_id

  def self.get_link_id name
    self.find_or_create_by_name(:name => name).id
  end

=begin
  def get_domain
    Domain.get_domain(self.name)
  rescue
    nil
  end
=end

  def domain_link? domain_name
   self.domain.name == domain_name
  end

  private
  def set_domain_id
   self.update_attribute(:domain_id, Domain.get_domain_id(self.name))
  end
end
