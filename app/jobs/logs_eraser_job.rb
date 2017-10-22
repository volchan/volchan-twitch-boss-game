class LogsEraserJob < ApplicationJob
  queue_as :default

  def perform(*_)
    logger = Logger.new(STDOUT)
    logger.info 'Deleting two weeks old logs!'
    logs_to_delete = Log.two_weeks_ago
    counter = 0
    logs_to_delete.each do |log|
      counter += 1
      log.destroy
    end
    logger.info "Deleted #{counter} logs!"
  end
end
