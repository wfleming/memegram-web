class MemegramsController < ApplicationController
  def show
    @meme = Meme.find(params[:id])
  end
end
