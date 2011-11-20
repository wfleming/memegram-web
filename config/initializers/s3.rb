AWS::S3::Base.establish_connection!(
  :access_key_id     => Configuration::S3.key,
  :secret_access_key => Configuration::S3.secret
)