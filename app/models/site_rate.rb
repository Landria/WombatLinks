require "rate"
require "rate_move"
class SiteRate < ActiveRecord::Base
  extend Rate
  include RateMove

  attr_accessible :domain_id, :prev_month, :prev_week, :this_month, :this_week
  attr_protected :total, :position, :prev_position

  belongs_to :domain

  self.per_page = 20

  def recount_rates
    links = UserLink.clear self.links

    links_total = Array.new(links)
    links_total.keep_if{|l| l.created_at >= self.updated_at}

    links_t_week = Array.new(links)
    links_t_week.keep_if{|l| l.created_at >= 7.days.ago}

    links_t_month = Array.new(links)
    links_t_month.keep_if{|l| l.created_at >= 1.months.ago}

    links_p_week = Array.new(links)
    links_p_week.keep_if{|l|  l.created_at >= 14.days.ago and l.created_at < 7.days.ago}

    links_p_month = Array.new(links)
    links_p_month.keep_if{|l| l.created_at >= 2.months.ago and l.created_at < 1.months.ago}

    self.update_attributes this_week: links_t_week.count, this_month: links_t_month.count, prev_week: links_p_week.count, prev_month: links_p_month.count
    self.update_attribute(:total, (self.total  + links_total.count))
  end

  def links
    self.domain.user_link
  end

  def self.get_rates page
    self.where('position > 0').order('total DESC').paginate(:page => page)
  end

end
