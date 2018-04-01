class Goal < ApplicationRecord
  belongs_to :user

  validates :g_type, presence: true
  validates :title, presence: true
  validates :required, presence: true, numericality: { only_integer: true, greater_than: 0 }

  enum g_type: { sub_goal: 0, bits_goal: 1 }
  enum status: { in_progress: 0, achieved: 1 }
end
