class BossGame < ApplicationRecord
  belongs_to :bot

  after_update :send_to_job

  private

  def send_to_job
    if current_hp_was > current_hp && !name_changed?
      event = 'damage_boss'
    elsif current_hp_was < current_hp && !name_changed?
      event = 'heal_boss'
    elsif shield_was < shield && current_hp == max_hp
      event = 'add_shield'
    elsif shield_was > shield
      event = 'damage_shield'
    elsif name_changed?
      event = 'new_boss'
    end
    BossGameJob.set(wait: 3.seconds).perform_later(id, event)
  end
end
