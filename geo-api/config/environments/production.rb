require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = true
  config.force_ssl = true
  config.log_tags = [ :request_id ]
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  io = ENV["RAILS_LOG_TO_STDOUT"].present? ? $stdout : File.open(config.paths["log"].first, "a")
  SemanticLogger.add_appender(io: io, formatter: :json)
  config.logger = GeoApi::Logger.new(logger: SemanticLogger["geo-api"])
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
end
