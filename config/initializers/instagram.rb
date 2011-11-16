file_name = Pathname(Rails.root)+'config'+'instagram.yml'
yaml = nil
if File.exist?(file_name)
  yaml = YAML.load(File.read(file_name))[Rails.env]
else # use env vars for the sake of Heroku
  yaml = {'app_id' => ENV['INSTAGRAM_APP_ID'],
          'app_secret' => ENV['INSTAGRAM_APP_SECRET']
          }
end

if yaml['app_id'].nil? || yaml['app_secret'].nil?
  raise ArgumentError.new('Expected complete Instagram config.')
end

Instagram.configure do |config|
  config.client_id = yaml['app_id']
  config.client_secret = yaml['app_secret']
end