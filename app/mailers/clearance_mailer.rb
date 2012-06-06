class ClearanceMailer < ActionMailer::Base
  def change_password(user)
    @user = user
    mail :from    => Clearance.configuration.mailer_sender,
         :to      => @user.email,
         :subject => I18n.t(:email_change_password,
                           :default => "Change your password")
  end
end