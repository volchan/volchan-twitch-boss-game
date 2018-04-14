class Goal < ApplicationRecord
  belongs_to :user

  validates :g_type, presence: true
  validates :title, presence: true
  validates :required, presence: true, numericality: { only_integer: true, greater_than: 0 }

  enum g_type: { sub_goal: 0, bits_goal: 1 }
  enum status: { in_progress: 0, achieved: 1, paused: 2 }

  after_create :broadcast_to_view

  after_update :check_status
  after_update :broadcast_to_view

  after_destroy :broadcast_destroyed_to_view

  private

  def check_status
    achieved! if current >= required && in_progress?
    in_progress! if current < required && achieved?
  end

  def broadcast_to_view
    if sub_goal?
      ActionCable.server.broadcast(
        "sub_goal_#{user.id}",
        JSON.parse(to_json(only: %I[title current required status]))
      )
    else
      ActionCable.server.broadcast(
        "bits_goal_#{user.id}",
        JSON.parse(to_json(only: %I[title current required status]))
      )
    end
  end

  def broadcast_destroyed_to_view
    if sub_goal?
      ActionCable.server.broadcast(
        "sub_goal_#{user.id}",
        deleted: true
      )
    else
      ActionCable.server.broadcast(
        "bits_goal_#{user.id}",
        deleted: true
      )
    end
  end
end
