module Configuration
  class Instagram
    @@app_id = nil
    @@app_secret = nil
  
    def self.load!
      file_name = Pathname(Rails.root)+'config'+'instagram.yml'
      yaml = nil
      if File.exist?(file_name)
        yaml = YAML.load(File.read(file_name))[Rails.env]
      else # use env vars for the sake of Heroku
        yaml = {'app_id' => ENV['INSTAGRAM_APP_ID'],
                'app_secret' => ENV['INSTAGRAM_APP_SECRET']
                }
      end

      if yaml.nil? || yaml['app_id'].nil? || yaml['app_secret'].nil?
        Rails.logger.warn('Expected complete Instagram config.')
      end
    
      @@app_id = yaml['app_id']
      @@app_secret = yaml['app_secret']
    end
  
    def self.app_id
      self.load! if @@app_id.nil?
      @@app_id
    end
  
    def self.app_secret
      self.load! if @@app_secret.nil?
      @@app_secret
    end
  end
end