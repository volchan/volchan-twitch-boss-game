module Dashboard
  class BotsController < ApplicationController
    before_action :set_bot, only: %i[update destroy]

    def new
      skip_authorization
      @bot = Bot.new
    end

    def create
      authorize @bot = Bot.new(bot_params)
      @bot.user = current_user
      if @bot.save
        create_boss(@bot)
        redirect_to dashboard_root_path
      else
        render :new
      end
    end

    def update
      respond_to do |format|
        if @bot.update(bot_params)
          flash.now[:notice] = 'Successfully updated !'
          format.js { render 'dashboard/bots/update' }
        else
          flash.now[:alert] = 'Something went wrong !'
          format.json { render json: @bot.errors, status: :unprocessable_entity }
          format.js   { render layout: false, content_type: 'text/javascript' }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @bot.destroy
          flash.now[:notice] = 'Bot successfully deleted !'
          format.js { render 'dashboard/dashboards/no_bot_index' }
        else
          flash.now[:alert] = 'Something went wrong !'
          format.js
        end
      end
    end

    private

    def create_boss(bot)
      Boss.create(
        bot: bot,
        name: 'No boss yet!',
        current_hp: 1,
        max_hp: 1,
        current_shield: 0,
        max_shield: 1
      )
    end

    def set_bot
      authorize @bot = Bot.find_bot(params[:id])
    end

    def bot_params
      params.require(:bot)
            .permit(:boss_max_hp,
                    :boss_min_hp,
                    :boss_hp_step,
                    :channel,
                    :sub_prime_modifier,
                    :sub_five_modifier,
                    :sub_ten_modifier,
                    :sub_twenty_five_modifier,
                    :bits_modifier)
    end
  end
end
