require_relative "boot"
require_relative "../lib/geo_api/logger"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module GeoApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.paths.add "lib", load_path: true, eager_load: true
    config.api_only = true
  end
end
