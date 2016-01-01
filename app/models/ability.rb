class Ability
  include CanCan::Ability

  def initialize(current_user)
    user ||= User.new # guest user (not logged in)
    if current_user.role == "admin"
      can :manage, :all
    elsif current_user.role == "moderator"

    elsif current_user.role == "author"
      can :update, Article, :user_id => current_user.id
      p current_user.id
      can :read, :all
    else

    end
  end
end
