module Profile
  class ProfilesController < ApplicationController
    def show
      stripe_api = StripeApi.new(current_user)
      authorize @user = current_user
      @customer = stripe_api.find_customer if @user.stripe_id
    end
  end
end
