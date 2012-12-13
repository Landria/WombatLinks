require 'net/http'
class MonitorJob < Resque::Job

  @queue = :MonitorJob

  def self.perform
    UserWatch.all.each do |uw|
      response = nil
      code = 0
      begin
        response = Net::HTTP.get_response(URI.parse(URI.encode(uw.domain.url)))
        code = response.code.to_i
      rescue
      ensure
        uwm = SitesMonitor.create domain: uw.domain, status: (response.is_a? Net::HTTPOK), code: code
        if !uwm.status
          Resque.enqueue(MonitorAlertMailJob, uwm, uw.user)if !uw.user.mailing_list_cancelled?('monitor') and uw.user.stats_accessible?
        end
      end
    end
  end

  def queue_job
    Resque.enqueue(MonitorJob)
  end
end
