class Link < ActiveRecord::Base
  has_many :user_link, :dependent => :destroy
  has_one :link_rate
  belongs_to :domain

  validates_presence_of :name
  validates :name,
            :format => {:with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix},
            :if => "!name.blank?"

  after_create :set_domain_id, :initialize_stats

  def self.get_link_id name
    self.find_or_create_by_name(:name => name).id
  end

  def domain_link? domain_name
   self.domain.name == domain_name
  end

  def clean_text text, truncate_i
    text['["'] = '' if text['["']
    text['"]'] = '' if text['"]']
    text.truncate(truncate_i, :omission => '&hellip;', :separator => ' ')
  end

  private
  def set_domain_id
   self.update_attribute(:domain_id, Domain.get_domain_id(self.name))
  end

  def initialize_stats
    LinkRate.create :link_id => self.id
  end
end
