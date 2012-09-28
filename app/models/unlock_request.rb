class UnlockRequest < ActiveRecord::Base
  belongs_to :user
  validates_inclusion_of :status, :in => [:new, :accepted, :declined]

  def status
    read_attribute(:status).to_sym
  end

  def status= (value)
    write_attribute(:status, value.to_s)
  end
end
