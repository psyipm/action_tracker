# frozen_string_literal: true

module ActionTracker
  module HttpGateway
    protected

    def request(path)
      Connection.new.get(path)
    end

    def response
      @response ||= Connection.new.get(@path)
    end

    def processed_path(collection_name, params)
      [collection_name, params.to_query].reject(&:blank?).compact.join('?')
    end

    def parse_response(response)
      ActionTracker::CollectionProxy.new response, self.class.model_name
    end
  end
end
