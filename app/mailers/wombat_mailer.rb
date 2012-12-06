class WombatMailer < ActionMailer::Base
  default :from => Devise.mailer_sender

  def send_link(user_link, locale = I18n.default_locale)
    @link = user_link
    I18n.locale = locale
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

  def send_unlock_notification user_id, locale = I18n.default_locale
    user = User.find(user_id) unless user
    I18n.locale = locale
    mail :to      => user.email,
         :subject => (t 'unlock.notification')
  end

  def send_email_to_admin(message)
    @message = message

    AdminUser.all.each do |admin|
      mail :to      => admin.email,
           :from    => @message.email_from,
           :subject => "WombatLinks contact message: " + @message.subject
    end
  end
end
