class MemePresenter < BasePresenter
  attr_reader :meme

  def initialize(meme=nil)
    @meme = meme
  end
  
  def all_data
    return nil unless @meme
    
    {
      :meme => {
        :id => @meme.id,
        :caption => @meme.caption,
        :instagram_source_id => @meme.instagram_source_id,
        :instagram_source_link => @meme.instagram_source_link,
        :user_id => @meme.user_id,
        :image_url => meme.s3_presentation_url,
        :link => memegram_url(@meme)
      }
    }
  end
end