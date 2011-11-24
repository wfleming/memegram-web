class Meme < ActiveRecord::Base
  S3_EXPIRATION = (60 * 60) # 60 minutes
  
  attr_accessor :validate_s3_resource_url
  after_initialize -> { self.validate_s3_resource_url = true }
  
  belongs_to :user
  
  validates :user, :presence => true
  validates :instagram_source_id, :presence => true
  validates :instagram_source_link, :presence => true
  validates :s3_resource_url, :presence => true, :if => :validate_s3_resource_url
  
  def attach_image!(image)
    resource_url = generate_s3_resource_url(image)
    response = AWS::S3::S3Object.store(resource_url, image.open, Configuration::S3.bucket)
    
    if !response.nil? && response.success?
      logger.debug("YAY! S3 upload worked!")
      self.s3_resource_url = resource_url
      true
    else
      logger.debug("S3 UPLOAD FAILED: respanse => #{response.inspect}, present? => #{response.present?.inspect}, success? => #{response.success?.inspect}")
      false
    end
  end
  
  def s3_object
    if self.s3_resource_url
      @s3_object ||= AWS::S3::S3Object.find(self.s3_resource_url, Configuration::S3.bucket)
    else
      nil
    end
  rescue AWS::S3::NoSuchKey => e
    Rails.logger.error("Couldn't find key for #{self} on S3! Badness! #{e}")
  end
  
  # a cached s3 presentation URL - used when cloudfront is not available
  # see presentation_url
  def s3_presentation_url
    obj = self.s3_object
    if obj.present?
      @s3_presentation_url ||= obj.url(:expires_in => S3_EXPIRATION)
    else
      nil
    end
  end
  
  # the presentation_url that should really be used - uses the asset host when defined,
  # falls back to S3 otherwise.
  def presentation_url
    if defined?(MEME_ASSET_HOST) && MEME_ASSET_HOST.present?
      "#{MEME_ASSET_HOST}/#{self.resource_url}"
    else
      self.s3_presentation_url
    end
  end
  
  def generate_s3_resource_url(image)
    ext = '.jpg'
    begin
      new_ext = File.extname(image.original_filename)
      ext = new_ext unless new_ext.blank?
    rescue Exception => e
      Rails.logger.error("Exception trying to figure out the extension: #{e}")
    end
    
    "user_#{self.user.id}/source_#{self.instagram_source_id}_at_#{Time.now.to_i}#{ext}"
  end
  private :generate_s3_resource_url
end
