# frozen_string_literal: true

require 'api_signature'
require 'httparty'

module ActionTracker
  class SignedRequest
    include ::HTTParty

    attr_reader :request_method, :url, :options

    delegate :config, to: :ActionTracker

    def initialize(request_method, url, options = {})
      @request_method = request_method.to_s.downcase
      @url = URI.parse(url)
      @options = options
    end

    def perform
      self.class.send(request_method, url, headers: headers, body: body, format: :json)
    end

    private

    def headers
      (options[:headers] || {}).merge(signature_headers)
    end

    def body
      options[:body]
    end

    def signature_headers
      ApiSignature::Builder.new(signature_options).headers
    end

    def signature_options
      {
        access_key: config.api_key,
        secret: config.api_secret,
        request_method: request_method,
        path: url.path
      }
    end
  end
end
