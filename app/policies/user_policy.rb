class UserPolicy < ApplicationPolicy
  def twitch?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
