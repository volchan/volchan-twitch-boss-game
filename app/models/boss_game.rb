class BossGame < ApplicationRecord
  belongs_to :bot

  after_create :send_to_job
  after_update :send_to_job

  private

  def send_to_job
    BossGameJob.set(wait: 3.seconds).perform_later(id)
  end
end
