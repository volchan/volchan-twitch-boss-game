class BossGameJob < ApplicationJob
  queue_as :default

  def perform(attr, boss)
    @game = Game.new(boss)
    if attr[:event_type] == 'sub'
      @game.sub_event(attr)
    elsif attr[:event_type] == 'bits'
      @game.bits_event(attr)
    end
  end
end
