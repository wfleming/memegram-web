class HomeController < ApplicationController
  exclude_mobile_for(:index)
  
  def index
    render :layout => false
  end
end
