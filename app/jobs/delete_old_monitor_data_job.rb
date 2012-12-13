class DeleteOldMonitorDataJob < Resque::Job

  @queue = :DeleteOldMonitorDataJob

  def self.perform
    period = Settings.monitor_data_storage_period.to_i
    monitor_data = SitesMonitor.where(["created_at < ?", period.months.ago])
    monitor_data.each do |md|
      md.destroy
    end
  end

  def queue_job
    Resque.enqueue(DeleteOldMonitorDataJob)
  end
end
