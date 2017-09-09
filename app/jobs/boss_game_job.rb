class BossGameJob < ApplicationJob
  queue_as :default

  def perform(attr)
    @game = Game.new(attr[:boss])
    event = attr[:event]
    if event[:event_type] == 'sub'
      @game.sub_event(event)
    elsif event[:event_type] == 'bits'
      @game.bits_event(event)
    end
  end
end
