class Log < ApplicationRecord
  belongs_to :bot

  scope :last_week_logs, ->() { where('created_at > ?', 1.week.ago) }
end
