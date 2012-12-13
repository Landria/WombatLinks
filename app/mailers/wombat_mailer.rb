class WombatMailer < ActionMailer::Base
  default :from => Devise.mailer_sender

  def send_link(user_link)
    @link = user_link
    I18n.locale = @link.user.locale if @link.user
    title = user_link.show_title

    mail :to      => user_link.email,
         :subject => I18n.t(:new_wombat_link) + ": "+ @link.show_title
  end

  def send_unlock_request
     User.where(:role == 'admin').each do |admin|
       mail :to      => admin.email,
            :subject => "New unlock request"
     end
  end

  def send_unlock_notification user_id
    user = User.find(user_id) unless user
    I18n.locale = user.locale.to_sym
    mail :to      => user.email,
         :subject => (t 'unlock_request.notification')
  end

  def send_email_to_admin(message)
    @message = message

    AdminUser.all.each do |admin|
      mail :to      => admin.email,
           :from    => @message.email_from,
           :subject => "WombatLinks contact message: " + @message.subject
    end
  end

  def send_monitor_alert user_watch_monitor, user
    I18n.locale = user.locale.to_sym
    @uwm = user_watch_monitor
    mail :to      => user.email,
         :subject => "WombatLinks Sites Monitor alert!"
  end
end
