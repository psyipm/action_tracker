# frozen_string_literal: true

module ActionTracker
  class ClientNotConfiguredError < StandardError; end

  class Config
    attr_writer :api_url, :api_key, :api_secret

    def api_url
      @api_url || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_url)
    end

    def api_key
      @api_key || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_key)
    end

    def api_secret
      @api_secret || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_secret)
    end

    def client
      OpenStruct.new(access_key: api_key, secret: api_secret)
    end
  end
end
