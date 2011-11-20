class OauthController < ApplicationController
  BASE_CALLBACK_URL = "http://#{HOST}/auth/instagram/callback"
  
  def instagram_callback
    callback_url = BASE_CALLBACK_URL
    # You must send Instagram the *exact* callback URL you requested, including params.
    if params[:client]
      callback_url = "#{callback_url}?client=#{params[:client]}"
    end
    
    logger.info("ASKING INSTAGRAM FOR TOKEN. WE GOT CODE #{params[:code]} && redirect_uri #{callback_url}. Our client_id is #{Instagram.client_id}")
    response = Instagram.get_access_token(params[:code], :redirect_uri => callback_url)
    logger.info("INSTAGRAM ACCESS RESPONSE IS #{response.inspect}")
    
    @user = User.find_or_create_from_instagram_oauth_response(response)
    
    if @user && @user.persisted?
      # right now the only client is iOS, so we redirect back without further checks
      redirect_to ios_client_callback_url(@user)
    else
      raise Exception.new("something bad happened which you should handle better")
    end
  end
  
  # the URL to redirect to on the client to get info back to the client
  def ios_client_callback_url(user)
    "memegram://auth_callback?instagram_token=#{user.instagram_token}&api_token=#{user.api_token}"
  end
  private :ios_client_callback_url
end
