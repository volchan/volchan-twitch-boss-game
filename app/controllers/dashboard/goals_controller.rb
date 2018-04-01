module Dashboard
  class GoalsController < ApplicationController
    def new_sub_goal
      authorize @goal = Goal.new(g_type: 0)
      respond_to do |format|
        format.js { render :new, layout: false }
      end
    end

    def new_bits_goal
      authorize @goal = Goal.new(g_type: 1)
      respond_to do |format|
        format.js { render :new, layout: false }
      end
    end

    def create; end

    def update; end

    def destroy; end
  end
end
