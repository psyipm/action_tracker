# frozen_string_literal: true

module ActionTracker
  module Workers
    class Inline
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def perform
        connection.post form.collection_path, body: form.present_attributes
      end

      private

      def connection
        @connection ||= ActionTracker::Connection.new
      end
    end
  end
end
