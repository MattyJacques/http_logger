# frozen_string_literal: true

# HTTPLogger is a simple HTTP request/response logger for Ruby applications.
module HTTPLogger
  class << self
    def log(params = {})
      log_request(params[:method], params[:url], params[:request])
      log_response(params[:response])
    end

    private

    def log_request(method, url, request)
      send_log("Request: #{method} #{url}")
      send_log("Headers: #{request[:headers].inspect}")
      send_log("Body: #{request[:body].inspect}") if request[:body]
    end

    def log_response(response)
      send_log("Response: #{response[:code]}")
      send_log("Headers: #{response[:headers].inspect}")
      send_log("Body: #{response[:body].inspect}") if response[:body]
    end

    def send_log(message)
      puts("[HTTPLogger] #{message}")
    end
  end
end
