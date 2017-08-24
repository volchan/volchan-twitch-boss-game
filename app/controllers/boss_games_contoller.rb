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

  def update_current_hp
    boss_game = BossGame.find(params[:id])
    boss_game.update(current_hp: params[:current_hp], saved_at: params[:saved_at])
  end

  def update_shield
    boss_game = BossGame.find(params[:id])
    boss_game.update(shield: params[:shield], saved_at: params[:saved_at])
  end


  private

  def authenticate_token
    bot = Bot.find(params[:bot_id])
    return unless params[:token].nil? || bot.token != params[:token]
    render :root
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
