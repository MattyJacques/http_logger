# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Net::HTTP do
  let(:http) { described_class.new('example.com', 80) }
  let(:request) { Net::HTTP::Get.new('/api/test') }
  let(:response) { Net::HTTPResponse.new('1.1', '200', 'OK') }

  before do
    allow(http).to receive(:original_connect)
    allow(HTTPLogger).to receive(:log)
  end

  describe '#connect' do
    it 'calls the original connect method' do
      expect(http).to receive(:original_connect)

      http.start
    end

    it 'logs connection details' do
      expect(HTTPLogger).to receive(:log_connection).with('example.com', 80)

      http.start
    end
  end

  describe '#request' do
    before do
      allow(response).to receive(:body).and_return(nil)
      allow(http).to receive(:original_request).with(request, nil).and_return(response)
    end

    it 'calls the original request method' do
      expect(http).to receive(:original_request).with(request, nil)

      http.request(request)
    end

    it 'logs request and response details' do
      expect(HTTPLogger).to receive(:log).with(
        method: 'GET',
        url: "http://#{http.address}:#{http.port}#{request.path}",
        request: { headers: request.each_header.to_h, body: nil },
        response: { headers: response.each_header.to_h, code: '200', body: nil }
      )

      http.request(request)
    end

    context 'with request body' do
      let(:request_body) { '{"key":"value"}' }
      let(:response_body) { '{"status":"success"}' }

      before do
        allow(response).to receive(:body).and_return(response_body)
        allow(http).to receive(:original_request).with(request, request_body).and_return(response)
      end

      it 'logs request body' do
        expect(HTTPLogger).to receive(:log).with(
          method: 'GET',
          url: "http://#{http.address}:#{http.port}#{request.path}",
          request: { headers: request.each_header.to_h, body: request_body },
          response: { headers: response.each_header.to_h, code: '200', body: response_body }
        )

        http.request(request, request_body)
      end
    end
  end
end
