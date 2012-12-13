class StatisticsMailJob < Resque::Job

  @queue = :MailJob

  def self.perform
    UserWatch.all.each do |uw|
     if !uw.user.mailing_list_cancelled?('rates') and uw.user.stats_accessible?
       WombatMailer.send_statistics(uw).deliver
     end
    end
  rescue
  end
end
