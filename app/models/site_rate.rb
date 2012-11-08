class SiteRate < ActiveRecord::Base
  attr_accessible :domain_id, :perv_month, :position, :prev_position, :prev_week, :this_month, :this_week, :total
end
