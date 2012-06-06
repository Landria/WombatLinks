class WombatMailer < ActionMailer::Base
  default :from => Clearance.configuration.mailer_sender
  
  def send_link(link)
    @link = link
    
    if (link.title.empty?)
       title = link.link 
    else
      title = link.title 
    end
    
    mail :to      => link.email,
         :subject => I18n.t(:new_wombat_link) + ": "+ title
  end
end
