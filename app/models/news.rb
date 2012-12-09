class News < ActiveRecord::Base
  validates :locale, presence: true, :inclusion => { :in => %w(ru en) }
  validates :title, presence: true
  validates :text, presence: true

  default_scope :order => "created_at DESC"
end
