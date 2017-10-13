class Log < ApplicationRecord
  belongs_to :bot

  scope :two_weeks_ago, ->() { where('created_at < ?', 2.weeks.ago) }
end
