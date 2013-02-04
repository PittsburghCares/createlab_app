# Be sure to restart your server when you modify this file

# Ruby 1.9.3 monkey patching
if RUBY_VERSION > "1.9"
  Encoding.default_external = Encoding.default_internal = Encoding::UTF_8
end

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem "geokit", :version => '1.6.5'
  config.gem "cocaine", :version => '0.3.0'
  config.gem "multi_json", :version => '1.3.6'
  config.gem "mysql2", :version => '0.2.18' # NOTE: OS specific, so must be installed manually (i.e. this isn't already bundled)
  config.gem 'mime-types', :version => '1.19', :lib => 'mime/types'

  config.active_record.observers = :user_observer
  
  # Mail settings
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => "pghmentoringstories.org" } # Host is the main website (e.g. the CREATE Lab website: cmucreatelab.org)
  config.action_mailer.default_content_type = "text/plain"
  config.action_mailer.default_charset = 'utf-8'
  
  # Site wide globals
  $organization_name = "The Mentoring Partnership"
  $main_outgoing_email = "bweaver@handsontechpgh.org"  
  $projects_name_replacement = "programs" # This is 'projects' on the main CREATE Lab website; (NOTE: must be plural)
  $pages_name_replacement = "stories"     # This is 'pages' on the main CREATE Lab website; (NOTE: must be plural)
  
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

end
