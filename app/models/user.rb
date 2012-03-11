class User < ActiveRecord::Base
  include Clearance::User

  ROLES = %w[admin guest user]

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def is?(role)
    roles.include?(role.to_s)
  end
end
