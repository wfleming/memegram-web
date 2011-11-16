class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  before_save :generate_api_token, :if => -> { api_token.blank? }
  
  def self.find_or_create_from_instagram_oauth_response(response)
    user = User.find_by_instagram_user_id(response.user.id)
    if user.blank? # this is a brand new user
      user = User.new
      user.instagram_username = response.user.username
      user.instagram_user_id = response.user.id
      user.instagram_avatar_url = response.user.profile_picture
    end
    # always update the access token in case it changed
    user.instagram_token = response.access_token
    user.save
    user
  end
  
  def generate_api_token
    Rails.logger.debug("User#generate_api_token CALLED")
    #TODO - ensure uniqueness in the DB before saving
    self.api_token = Digest::SHA1.hexdigest("#{id}-#{instagram_user_id}-#{instagram_username}-#{Time.now}")
  end
end
