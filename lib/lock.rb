class Lock

  def self.exists? link_id
    if SpamLink.find_by_link_id(link_id)
      true
    else
      false
    end
  end

  def self.update link_id
    if self.exists? link_id
      SpamLink.find_by_link_id(link_id).update_count
    else
      fasle
    end
  end

  def self.create link
    if link.is_a? Link
      lock = SpamLink.new(:link_id => link.id, :comment => "Complain via email")
      lock.save
      if link.user_id && !LockedUser.find_by_user_id(link.user_id)
        LockedUser.new(:user_id => link.user_id, :spam_link_id => lock.id).save
      else
        if !LockedEmail.find_by_email(link.email)
          LockedEmail.new(:email => link.email, :spam_link_id => lock.id).save
        end
      end
    end
  end

end