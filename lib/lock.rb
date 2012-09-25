class Lock

  def self.exists?
    SpamLink.find_by_link_id(@link.id)
  end

  def self.lock link
    if link.is_a? Link
      SpamLink.new(:link_id => link.id, :comment => "Complain via email").save
      if link.user_id && !LockedUser.find_by_user_id(link.user_id)
        LockedUser.new(:user_id => link.user_id).save
      else
        if !LockedEmail.find_by_email(link.email)
          LockedEmail.new(:email => link.email).save
        end
      end
    end
  end

end