begin
  AWS::S3::Base.establish_connection!(
    :access_key_id     => Configuration::S3.key,
    :secret_access_key => Configuration::S3.secret
  )
rescue Exception => e
  Rails.logger.warn("SERIOUS LIKELIHOOD OF BADNESS: we were not able to connect to S3. Details: #{e}")
end