class BossPolicy < ApplicationPolicy
  def update?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
