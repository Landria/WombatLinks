class SiteRate < ActiveRecord::Base
  attr_accessible :domain_id, :prev_month, :position, :prev_position, :prev_week, :this_month, :this_week, :total

  def self.recount_rates
    links = Link.all
    domains = Domain.all
    this_week = prev_week = this_month = prev_month = 0

    domains.each do |domain|
      links.each do |link|
        if link.domain_link? domain.name
          total = UserLink.where(:link_id => link.id).count
          this_week = UserLink.where(:link_id => link.id, :created_at => (7.days.ago)..Time.now ).count
          perv_week = UserLink.where(:link_id => link.id, :created_at => (14.days.ago)..(7.days.ago) ).count
        end
      end
    end
  end
end
