class Goal < ApplicationRecord
  belongs_to :user

  validates :g_type, presence: true
  validates :title, presence: true
  validates :required, presence: true, numericality: { only_integer: true, greater_than: 0 }

  enum g_type: { sub_goal: 0, bits_goal: 1 }
  enum status: { in_progress: 0, achieved: 1 }

  after_update :broadcast_to_view

  private

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
end
