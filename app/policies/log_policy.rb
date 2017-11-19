class LogPolicy < ApplicationPolicy
  def show?
    true
  end
  
  class Scope < Scope
    def resolve
      scope.where(bot: user.bot).order(created_at: :desc)
    end
  end
end
