require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false


  config.eager_load = ENV["CI"].present?
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.action_controller.raise_on_missing_callback_actions = true

  SemanticLogger.add_appender(io: $stdout, level: :warn, formatter: :color) if ENV["SHOW_LOGS"]
  config.logger = GeoApi::Logger.new(logger: SemanticLogger["geo-api-test"])
end
