# frozen_string_literal: true

module ActionTracker
  class ClientNotConfiguredError < StandardError; end

  class Config
    def initialize
      @api_url = ENV['ACTION_TRACKING_API_URL']
      @api_key = ENV['ACTION_TRACKING_API_KEY']
      @api_secret = ENV['ACTION_TRACKING_API_SECRET']
    end

    def api_url
      @api_url.presence || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_url)
    end

    def api_key
      @api_key.presence || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_key)
    end

    def api_secret
      @api_secret.presence || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_secret)
    end

    def client
      OpenStruct.new(access_key: api_key, secret: api_secret)
    end
  end
end
