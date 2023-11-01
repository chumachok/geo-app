module GeoApi
  class Logger

    attr_accessor :logger

    def initialize(logger:)
      @logger = logger
    end

    def debug(*args, &block)
      return unless logger.debug?
      log(:debug, *args, &block)
    end

    def error(*args, &block)
      return unless logger.error?
      log(:error, *args, &block)
    end

    def fatal(*args, &block)
      return unless logger.fatal?
      log(:fatal, *args, &block)
    end

    def info(*args, &block)
      return unless logger.info?
      log(:info, *args, &block)
    end

    def warn(*args, &block)
      return unless logger.warn?
      log(:warn, *args, &block)
    end

    def trace(*args, &block)
      return unless logger.trace?
      log(:trace, *args, &block)
    end

    def log(level, *args, &block)
      message, payload, exception = block ? unpack_log_args([block.call].flatten) : unpack_log_args(args)

      logger.send(level, message: message, payload: payload, exception: exception)
    end

    def unpack_log_args(args)
      if args.first.respond_to?(:keys)
        if args.size != 1
          raise ArgumentError.new("wrong number of arguments (given #{args.size}, expected 1)")
        end
        keywords = args.first
        allowed = [:message, :payload, :exception]
        keywords.keys.each do |k|
          if !allowed.include?(k)
            raise ArgumentError.new("unknown keyword: #{k}")
          end
        end
        [keywords[:message], keywords[:payload], keywords[:exception]]
      else
        if args.size < 1 or args.size > 3
          raise ArgumentError.new("wrong number of arguments (given #{args.size}, expected 1..3)")
        end
        args
      end
    end

    def method_missing(method, *args, &block)
      logger.send(method, *args, &block)
    end

    def info?
      logger.info?
    end
  end
end
