class HomeController < ApplicationController
  exclude_mobile_for(:index)

  def index
    expires_in 1.hour
    render :layout => false
  end
end
