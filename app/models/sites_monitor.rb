class SitesMonitor < ActiveRecord::Base
  belongs_to :domain, :dependent => :delete

  attr_accessible :status, :domain, :code

end
