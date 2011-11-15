class Api::ApiController < ApplicationController
  before_filter :auth_user

  def auth_user
    #TODO
  end
end
