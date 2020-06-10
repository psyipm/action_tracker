# frozen_string_literal :true

module ActionTracker
  module Models
    class StatisticRecord < ActionTracker::Models::ApplicationRecord
      include ActionTracker::HttpGateway

      attribute :user_id, String
      attribute :report_date, String
      attribute :total_count, Integer
      attribute :targets, Hash

      def count(params = {})
        request processed_path(collection_path, params)
      end

      def daily(params = {})
        path = processed_path("#{collection_path}/daily", params)
        parse_response request(path)
      end

      def collection_path
        'statistics'
      end
    end
  end
end
