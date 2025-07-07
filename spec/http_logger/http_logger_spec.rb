# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HTTPLogger do
  describe '.config' do
    it 'returns a config object' do
      expect(described_class.config).to be_a(HTTPLogger::Config)
    end

    it 'has default config values' do
      config = described_class.config
      expect(config.log_request).to be(true)
      expect(config.log_response).to be(true)
      expect(config.log_connection).to be(true)
    end
  end

  describe '.configure' do
    after do
      # Reset config to defaults after each test
      described_class.configure do |config|
        config.log_request = true
        config.log_response = true
        config.log_connection = true
      end
    end

    it 'yields the config object' do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class.config)
    end

    it 'allows changing config options' do
      described_class.configure do |config|
        config.log_request = false
        config.log_response = false
        config.log_connection = false
      end

      config = described_class.config

      expect(config.log_request).to be(false)
      expect(config.log_response).to be(false)
      expect(config.log_connection).to be(false)
    end
  end

  describe '.log' do
    let(:request) { { headers: { 'Content-Type' => 'application/json' }, body: '{"foo":"bar"}' } }
    let(:response) { { code: 200, headers: { 'Content-Length' => '123' }, body: '{"baz":"qux"}' } }
    let(:params) { { method: 'GET', url: 'http://example.com', request: request, response: response } }

    it 'logs request and response when enabled' do
      output = capture_stdout { described_class.log(params) }
      expect(output).to include('[HTTPLogger] Request: GET http://example.com')
      expect(output).to include('[HTTPLogger] Response: 200')
    end

    def capture_stdout
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end

    it 'does not log request when log_request is false' do
      described_class.config.log_request = false
      expect { described_class.log(params) }.not_to output(/Request:/).to_stdout
      described_class.config.log_request = true
    end

    it 'does not log response when log_response is false' do
      described_class.config.log_response = false
      expect { described_class.log(params) }.not_to output(/Response:/).to_stdout
      described_class.config.log_response = true
    end
  end
end
