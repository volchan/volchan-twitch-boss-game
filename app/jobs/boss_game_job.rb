class BossGameJob < ApplicationJob
  queue_as :default

  def perform(attr)
    # Do something later
  end
end
