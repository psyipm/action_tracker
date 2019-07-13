# frozen_string_literal: true

module ActionTracker
  class Connection
    [:get, :post, :patch, :put, :delete].each do |type|
      define_method type do |path, options = {}|
        perform_request(type, path, options)
      end
    end

    private

    def perform_request(type, path, options)
      url = File.join(config.api_url, path)
      ActionTracker::SignedRequest.new(type, url, options).perform
    end

    def config
      @config ||= ActionTracker.config
    end
  end
end
