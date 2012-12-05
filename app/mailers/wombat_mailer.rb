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

  def send_unlock_notification user, locale = I18n.default_locale
    I18n.locale = locale
    mail :to      => user.email,
         :subject => (t 'unlock.notification')
  end
end
