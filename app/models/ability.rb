class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == "admin"
      can :manage, :all
      cannot :edit, Article
    elsif user.role == "moderator"
      can [:create, :update, :edit, :destroy], Article, user_id: user.id
      can :destroy, Article
      can [:index, :all, :show], Article
      can :show, User
      cannot [:tools, :toggleMod], User
    elsif user.role == "author"
      can [:create, :update, :destroy], Article, user_id: user.id
      can [:index, :all, :show], Article
      can :show, User
      cannot [:tools, :toggleMod], User
    else
      can :read, Article
      can :read, User
      cannot [:tools, :toggleMod], User
    end
  end
end
