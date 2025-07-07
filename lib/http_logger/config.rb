# frozen_string_literal: true

module HTTPLogger
  # Config class for HTTPLogger
  # This class holds configuration options for logging HTTP requests and responses.
  #
  # @example
  #   HTTPLogger.configure do |config|
  #     config.log_request = false
  #     config.log_response = false
  #     config.log_connection = false
  #   end
  #  # @see HTTPLogger.configure
  #
  # @attr_accessor [Boolean] log_request Whether to log HTTP requests.
  # @attr_accessor [Boolean] log_response Whether to log HTTP responses.
  # @attr_accessor [Boolean] log_connection Whether to log connection details.
  class Config
    attr_accessor :log_request, :log_response, :log_connection

    def initialize
      @log_request = true
      @log_response = true
      @log_connection = true
    end
  end
end
