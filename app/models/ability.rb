class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "admin"
      can :manage, :all
    elsif user.role == "moderator"
      can :manage, Article
      cannot [:tools, :toggleMod], User
      can :read, :all
    elsif user.role == "author"
      can :update, Article, user_id: user.id
      p user.id
      can :read, :all
    else

    end
  end
end
