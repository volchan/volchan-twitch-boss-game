class BossGames < ApplicationController

  before_action :authenticate_token

  def create_boss
    BossGame.create(boss_game_params)
  end

  def update_boss
    BossGame.update(boss_game_params)
  end

  private

  def authenticate_token
    return unless params[:token].nil? || @bot.token != params[:token]
  end

  def boss_game_params
    {
      bot: Bot.find(params[:bot_id]),
      name: params[:name],
      max_hp: params[:max_hp],
      current_hp: params[:current_hp],
      shield: params[:shield],
      avatar: params[:avatar]
    }
  end
end
