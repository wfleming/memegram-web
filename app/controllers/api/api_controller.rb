class Api::ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # Returns the current user, as determined by the headers and request params.
  # Returns nil if no authentication token was supplied.
  def current_user
    return @current_user if @current_user

    token = request.headers['X-Auth-Token'].presence || params[:token].presence
    return nil if token.blank?
    @current_user ||= User.find_by_api_token(token)
  end

  # Meant to be used as a before_filter, this method will return an error
  # status if current_user.nil?
  def authenticate!
    error! :unauthorized and return false unless current_user
  end
  
  # Call this method to render an error response for a request.
  #
  # status can be any HTTP status. Defaults to :internal_server_error
  # payload can be anything that can be serialized to json
  # TODO: wrap the payload & try to be nice like Instagram API with JSON & a meta key?
  def error!(status = :internal_server_error, payload = nil)
    respond_to do |format|
      format.json {
        if payload.blank?
        then render :status => status, :nothing => true
        else render :status => status,
               :json => { 'errors' => Array.wrap(payload) }
        end
      }
    end
  end
end
