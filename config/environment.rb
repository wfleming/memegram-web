# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Memogram::Application.initialize!


# global app setup that is not environment specific, but which depends on
# specific environment things, should go here
Memogram::Application.configure do
  # Mailer setup
  config.action_mailer.default_url_options = { :host => HOST }
end
