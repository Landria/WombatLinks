class Lock

  def self.exists? link
    SpamLink.find_by_link_id(link.id)
  end

  def self.create link
    begin
      if link.is_a? Link
        if !LockedEmail.find_by_email(link.email) && !link.user_id
          LockedEmail.new(:email => link.email).save
        end
        SpamLink.new(:link_id => link.id, :comment => "Complain via email").save
        true
      else
        false
      end
    rescue
      false
    end
  end

end