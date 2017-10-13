class LogsEraserJob < ApplicationJob
  queue_as :default

  def perform(*_)
    logger = Logger.new(STDOUT)
    logger.info 'Deleting last weeks logs!'
    logs_to_delete = Log.last_week_logs
    logs_to_delete.each(&:destroy)
    logger.info 'Done deleting logs!'
  end
end
