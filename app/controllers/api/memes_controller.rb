class Api::MemesController < Api::ApiController
  before_filter :authenticate!
  
  def index
    #TODO
  end
  
  def create
    attrs = begin
      ActiveSupport::JSON.decode(params[:memegram])
    rescue Exception => e
      logger.debug("ERROR DECODING JSON: #{e}\n(The String was \"#{params[:memegram]}\")")
      nil
    end
    image = params[:imageData]
    
    if image.blank? || attrs.blank?
      #TODO detailed message
      logger.debug("BAD REQUEST - image or attrs is blank")
      error! :bad_request
      return
    end
  
    # first, setup the model
    meme = Meme.new(attrs)
    meme.user = current_user
    
    meme.validate_s3_resource_url = false
    if !meme.valid?
      logger.debug("MEME NOT VALID BEFORE S3 UPLOAD ATTEMPT: #{meme.errors.inspect}")
      error! :bad_request
      return
    end
    meme.validate_s3_resource_url = true
    
    # if it's valid *without* the actual image Data, attempt to save the image to S3
    did_attach = meme.attach_image!(image)
    
    if !did_attach || !meme.valid?
      logger.debug("UPLOAD NOT SUCCESSFUL OR MEME NOT VALID: did_attach => #{did_attach.inspect}, meme => #{meme.errors.inspect}")
      error! :internal_server_error
      return
    end
    
    meme.save
    
    # render back to client (with S3 URL & web URL information)
    if meme.persisted?
      logger.debug("IT ACTUALLy FUCKING WORKED!")
      render :json => MemePresenter.new(meme).all_data
    else
      error! :internal_server_error
    end
  end
end
