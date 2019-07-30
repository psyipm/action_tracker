# frozen_string_literal: true

module ActionTracker
  class ClientNotConfiguredError < StandardError; end
  class InvalidTrackingMethodError < StandardError; end

  class Config
    VALID_TRACKING_METHODS = [
      :inline, :custom, :test
    ].freeze

    attr_writer :api_url, :api_key, :api_secret, :custom_worker_proc

    def api_url
      @api_url || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_url)
    end

    def api_key
      @api_key || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_key)
    end

    def api_secret
      @api_secret || raise(ActionTracker::ClientNotConfiguredError, missing_value: :api_secret)
    end

    def tracking_method
      @tracking_method ||= :inline
    end

    def tracking_method=(value)
      raise(InvalidTrackingMethodError, value) unless VALID_TRACKING_METHODS.include?(value)

      @tracking_method = value
    end

    def custom_worker_proc
      @custom_worker_proc ||= ->(form) { ActionTracker::Workers::Inline.new(form).perform }
    end
  end
end
