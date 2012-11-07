class WombatMailer < ActionMailer::Base
  default :from => Devise.mailer_sender

  def send_link(user_link, locale = I18n.default_locale)
    @link = user_link
    I18n.locale = locale
    if (user_link.title.empty?)
       title = user_link.link
    else
      title = user_link.title
    end

    mail :to      => user_link.email,
         :subject => I18n.t(:new_wombat_link) + ": "+ title
  end

  def send_unlock_request
     User.where(:role == 'admin').each do |admin|
       mail :to      => admin.email,
            :subject => "New unlock request"
     end
  end
end
