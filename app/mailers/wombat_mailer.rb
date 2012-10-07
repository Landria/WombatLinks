class WombatMailer < ActionMailer::Base
  default :from => Devise.mailer_sender

  def send_link(link, locale = I18n.default_locale)
    @link = link
    I18n.locale = locale
    if (link.title.empty?)
       title = link.link
    else
      title = link.title
    end

    mail :to      => link.email,
         :subject => I18n.t(:new_wombat_link) + ": "+ title
  end

  def send_unlock_request
     User.where(:role == 'admin').each do |admin|
       mail :to      => admin.email,
            :subject => "New unlock request"
     end
  end
end
