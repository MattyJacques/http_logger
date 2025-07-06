# frozen_string_literal: true

require 'net/http'

module Net
  # This class hooks into Net::HTTP connect and request methods
  class HTTP
    alias original_connect connect
    alias original_request request

    def connect
      # Hook before connect

      original_connect

      # Hook after connect
      puts "[HTTPLogger] Connected to #{address}:#{port}"
    end

    def request(req, body = nil, &)
      # Hook before request

      response = original_request(req, body, &)

      # Hook after request
      log_request(req, body, response)

      response
    end

    private

    def log_request(req, body, response)
      HTTPLogger.log(
        method: req.method,
        url: "http://#{address}:#{port}#{req.path}",
        request: { headers: req.each_header.to_h, body: body },
        response: { headers: response.each_header.to_h, code: response.code, body: response.body }
      )
    end
  end
end
