yaml = YAML.load(File.read(Pathname(Rails.root)+'config'+'instagram.yml'))[Rails.env]

Instagram.configure do |config|
  config.client_id = yaml['app_id']
  config.client_secret = yaml['app_secret']
end