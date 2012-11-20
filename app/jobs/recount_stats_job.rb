class RecountStatsJob < Resque::Job

  @queue = :RecountStatsJob

  def self.perform
    SiteRate.recount_all_rates
    LinkRate.recount_all_rates
  end

  def queue_job
    Resque.enqueue(RecountStatsJob)
  end
end
