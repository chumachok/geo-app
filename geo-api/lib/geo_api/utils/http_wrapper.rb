require "http"

module GeoApi
  module Utils
    class HttpWrapper
      attr_reader :base_url, :params, :headers, :timeout
      DEFAULT_TIMEOUT = { connect: 5, write: 5, read: 10 }.freeze


      def initialize(base_url, headers: {}, timeout: DEFAULT_TIMEOUT)
        @base_url = base_url.chomp("/")
        @headers = headers
        @timeout = timeout
      end

      def get(path, params: nil, headers: {}, timeout: {})
        request(:get, path, params: params, headers: headers, timeout: timeout)
      end

      def head(path, params: nil, headers: {}, timeout: {})
        request(:head, path, params: params, headers: headers, timeout: timeout)
      end

      def post(path, params: nil, headers: {}, timeout: {}, form: nil, json: nil, body: nil)
        request(:post, path, params: params, headers: headers, timeout: timeout, form: form, json: json, body: body)
      end

      def put(path, params: nil, headers: {}, timeout: {}, form: nil, json: nil, body: nil)
        request(:put, path, params: params, headers: headers, timeout: timeout, form: form, json: json, body: body)
      end

      def delete(path, params: nil, headers: {}, timeout: {}, form: nil, json: nil, body: nil)
        request(:delete, path, params: params, headers: headers, timeout: timeout, form: form, json: json, body: body)
      end

      def to_h
        {
          base_url: @base_url,
          params: @params,
          headers: @headers,
          timeout: @timeout,
        }
      end

      class << self
        def method_missing(m, *args, &block)
          return super unless method_defined?(m)
          new("").send(m, *args, &block)
        end

        def respond_to_missing?(m, *)
          method_defined?(m)
        end
      end

      private
      def request(method, path, args)
        timeout = @timeout.merge(args.delete(:timeout))
        args[:headers] = headers.merge(args[:headers])
        connection = HTTP.timeout(timeout)
        connection.request(method, base_url + path, args)
      rescue HTTP::ConnectionError => ce
        raise ConnectionError, ce.message
      rescue HTTP::TimeoutError => te
        raise TimeoutError, te.message
      end

      class HttpError < StandardError; end
      class ConnectionError < HttpError; end
      class TimeoutError < HttpError; end
    end
  end
end
