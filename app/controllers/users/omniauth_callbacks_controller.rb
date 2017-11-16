module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def twitch
      user = policy_scope(User.find_for_twitch_oauth(request.env['omniauth.auth']))

      if user.persisted?
        authorize user
        sign_in_and_redirect user, event: :authentication
        return unless is_navigational_format?
        set_flash_message(:notice, :success, kind: 'Twitch')
      else
        session['devise.twitch_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end
end
