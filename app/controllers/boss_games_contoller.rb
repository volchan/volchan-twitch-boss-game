class BossGamesController < ApplicationController

  skip_before_action :authenticate_user!

  before_action :authenticate_token

  def create_boss
    BossGame.create(boss_game_params)
  end

  def update_boss
    boss_game = BossGame.find(params[:id])
    boss_game.update(boss_game_params)
  end

  private

  def authenticate_token
    boss_game = BossGame.find(params[:id])
    return unless params[:token].nil? || boss_game.bot.token != params[:token]
    render :root
  end

  def boss_game_params
    {
      bot: Bot.find(params[:bot_id].to_i),
      name: params[:name],
      max_hp: params[:max_hp].to_i,
      current_hp: params[:current_hp].to_i,
      shield: params[:shield].to_i,
      avatar: params[:avatar]
    }
  end
end
