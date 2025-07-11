# frozen_string_literal: true

require_relative 'config'

# HTTPLogger is a simple HTTP request/response logger for Ruby applications.
module HTTPLogger
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end

    def log(params = {})
      log_request(params[:method], params[:url], params[:request]) if config.log_request
      log_response(params[:response]) if config.log_response
    end

    def log_connection(host, port)
      send_log("Connected to #{host}:#{port}") if config.log_connection
    end

    private

    def log_request(method, url, request)
      send_log("Request: #{method} #{url}")
      log_headers(request[:headers])
      send_log("Body: #{request[:body].inspect}") if request[:body]
    end

    def log_response(response)
      send_log("Response: #{response[:code]}")
      log_headers(response[:headers])
      send_log("Body: #{response[:body].inspect}") if response[:body]
    end

    def log_headers(headers)
      return unless config.log_headers

      send_log("Headers: #{headers.inspect}")
    end

    def log_body(body)
      return unless body

    end

    def send_log(message)
      puts("[HTTPLogger] #{message}")
    end
  end
end
