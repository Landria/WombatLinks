class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if user.blank?
      can :index, Link
      can :new, Link
      can :show, Link
      can :create, Link
    end
    if user
      if user.is_locked?
        can :index, Link
        can :show, Link
        can :new, Link
        can :destroy, Link do |link|
          link.user_id == user.id
        end
      else
        if user.role == 'admin'
          can :manage, :all
        else
          can :show, Link do |link|
            !link.is_private? || link.user == user
          end
          can :index, Link
          #can :new, Link

          can :create, Link
          can :destroy, Link do |link|
            link.user_id == user.id
          end
          can :new, Link do |link|
            user.is_locked?
          end
          can :resend, Link do |link|
            (!link.is_private? and !link.is_spam?)|| (link.user == user and !link.is_spam?)
          end
        end
      end
    end
  end
end
