class Plan < ActiveRecord::Base
  attr_accessible :name, :price, :sites_count

  validates :name, :presence => true
  validates :price, :presence => true
  validates :sites_count, :presence => true

  def free?
    self.price.to_f === 0
  end

  def self.get_free
    self.where(:price => 0).first
  end

  def self.get_suitable
    get_free || self.all.first
  end
end
