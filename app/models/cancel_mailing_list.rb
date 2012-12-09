class CancelMailingList < ActiveRecord::Base
  attr_accessible :list_type, :user_id
  belongs_to :user

  validates :user_id, presence: true, numericality: :only_integer
  validates :list_type, presence: true, :inclusion => { :in => %w(rates monitor) }

  def self.change_status user_id, list_type
    list = where("user_id = ? AND list_type = ?", user_id, list_type).first
    if list
      return true if list.destroy
    else
      list = self.new user_id: user_id, list_type: list_type
      return true if list.save
    end
    false
  rescue
    false
  end
end
