class Lock

  def self.create link
    begin
      if link.is_a? UserLink
        if !LockedEmail.find_by_email(link.email) && !link.user_id
          LockedEmail.new(:email => link.email).save
        end
        link.update_attribute(:is_spam, true)
        true
      else
        false
      end
    rescue
      false
    end
  end

end