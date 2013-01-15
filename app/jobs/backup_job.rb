class BackupJob < Resque::Job

  @queue = :BackupJob

  def self.perform
    system("backup perform --trigger wombat_backup")
  end
end
