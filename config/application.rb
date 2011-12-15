require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

SITE_NAME = "Instagramz"

module Memegram
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/presenters)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :token]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    # do not use database when precompiling assets
    # (good for performance, also required by Heroku)
    config.assets.initialize_on_precompile = false
    
    # workaround for rails_admin not precompiling correctly when initialize_on_precompile == false
    # see https://github.com/sferik/rails_admin/issues/765
    config.assets.precompile += %w( rails_admin/rails_admin.css rails_admin/rails_admin.js )
    
    # workaround for all sorts of delightful things being broken by initialize_on_precompile == false
    %w(javascripts stylesheets).each do |dir_name|
      dir = Dir.open(Rails.root + 'app' + 'assets' + dir_name)
      dir.grep(/^[A-Za-z].+\.(js|css)\..+/).each do |file_name|
        logical_path = file_name.gsub(File.extname(file_name), '')
        config.assets.precompile << logical_path
      end
    end
  end
end
