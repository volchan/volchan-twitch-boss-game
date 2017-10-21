class Log < ApplicationRecord
  belongs_to :bot

  scope :two_weeks_ago, ->() { where('created_at < ?', 2.weeks.ago) }
  scope :find_with_bot, lambda { |bot|
                          where('bot_id = ?', bot.id)
                            .order(created_at: :desc)
                        }
end
