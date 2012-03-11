class Link < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :link, :email
  validates :link, 
              :format => { :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix },
              :if => "!link.blank?"              
  validates :email,
              :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
              :if => "!email.blank?" 
end
