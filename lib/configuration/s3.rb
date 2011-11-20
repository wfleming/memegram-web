module Configuration
  class S3
    @@key = nil
    @@secret = nil
    @@bucket = nil
  
    def self.load!
      file_name = Pathname(Rails.root)+'config'+'aws.yml'
      yaml = nil
      if File.exist?(file_name)
        yaml = YAML.load(File.read(file_name))[Rails.env]
      else # use env vars for the sake of Heroku
        puts "PULLING S3 FROM THE ENV: KEY IS #{ENV['S3_KEY']}, SECRET IS #{ENV['S3_SECRET']}"
        yaml = {'key' => ENV['S3_KEY'],
                'secret' => ENV['S3_SECRET'],
                'bucket' => ENV['S3_BUCKET']
                }
      end

      if yaml.nil? || yaml['key'].nil? || yaml['secret'].nil? || yaml['bucket'].nil?
        Rails.logger.warn("Expected complete S3 config.")
      end
    
      @@key = yaml['key']
      @@secret = yaml['secret']
      @@bucket = yaml['bucket']
    end
  
    def self.key
      self.load! if @@key.nil?
      @@key
    end
  
    def self.secret
      self.load! if @@secret.nil?
      @@secret
    end
    
    def self.bucket
      self.load! if @@bucket.nil?
      @@bucket
    end
  end
end