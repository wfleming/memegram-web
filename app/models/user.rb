class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  before_save :generate_api_token, :if => -> { api_token.blank? }
  
  def generate_api_token
    #TODO - ensure uniqueness in the DB before saving
    api_token = Digest::SHA1.hexdigest("#{id}-#{instagram_id}-#{instagram_username}-#{Time.now}")
  end
end
