class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :validate_unprotected
  def instagram
    # @user = User.find_or_create_for_instagram_oauth(env["omniauth.auth"])

    # user doesn't exist
    if @user && @user.persisted?
      # send back to the app with tokens
    else
      #failure condition to deal with
    end
  end

  def failure
    #TODO: LOGGING! feedback!
    render :layout => false
  end
end
