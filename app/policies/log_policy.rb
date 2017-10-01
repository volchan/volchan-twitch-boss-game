class LogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(bot: user.bot)
    end
  end
end
