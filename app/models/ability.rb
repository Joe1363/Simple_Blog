class Ability
  include CanCan::Ability

  def initialize(user)
    unless user
      can :read, [Article, User, Comment]
      can [:all, :search], Article
      cannot [:create, :edit, :update, :destroy], Comment
      cannot [:tools, :toggleMod], User
    else
      if user.role == "admin"
        can :manage, :all
        cannot :edit, Article
        cannot :edit, Comment
      elsif user.role == "moderator"
        can [:create, :update, :edit, :destroy], Article, user_id: user.id
        can :destroy, Article
        can [:index, :all, :show, :search], Article
        can [:create, :update, :edit], Comment, user_id: user.id
        can :destroy, Comment
        can :show, User
        cannot [:tools, :toggleMod], User
      elsif user.role == "author"
        can [:create, :index, :all, :show, :search], Article
        can [:update, :destroy], Article, user_id: user.id
        can [:create, :update, :edit, :destroy], Comment, user_id: user.id
        can :show, User
        cannot [:tools, :toggleMod], User
      end
    end
  end
end
