class RecountUserStatsJob < Resque::Job

  @queue = :RecountUserStatsJob

  def self.perform id
    rates = SiteRate.find(id)
    rates.recount_rates

    SiteRate.reset_positions

    rates.domain.link.each do |link|
      link.link_rate.recount_rates
    end

    LinkRate.reset_positions
    SiteRate.get_alexa_rank
  end

  def queue_job
    Resque.enqueue(RecountUserStatsJob)
  end
end
