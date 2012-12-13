class MonitorAlertMailJob < Resque::Job

  @queue = :MailJob

  def self.perform uwm, user
    WombatMailer.send_monitor_alert(uwm, user).deliver
  end
end
