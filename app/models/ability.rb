class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user && user.admin?
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      can :dashboard
      can :manage, :all
    else
      can [:destroy, :update], User, id: user.id                   # allow everyone to read everything
    end
    can :read, Category
    can :read, Interest
    can :read, User
    can :read, UserInterest
    if user.persisted?
      can [:create, :read, :destroy_all], Message
      can :create, Interest
      # can [:destroy, :update], User, id: user.id
      can :create, UserInterest
      can :destroy, UserInterest, user_id: user.id
      can [:read, :create], Question
      can :destroy, Question, user_id: user.id
      can [:read, :create], Answer
      can [:update, :destroy], Answer do |answer|
        answer.question.user_id == user.id
      end
      can [:create, :read, :destroy], Hail
      can :update, Hail do |hail|
        user.id == hail.to_user_id
      end
      can [:create, :index], UserBlock
      can :destroy, UserBlock, user_id: user.id
      can [:create, :read], UserSetting
    else
      can :create, User
    end
  end
end
