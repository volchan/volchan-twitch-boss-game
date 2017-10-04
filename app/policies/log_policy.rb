class LogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(bot: user.bot).order(created_at: :desc)
    end
  end
end
