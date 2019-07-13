# frozen_string_literal: true

module ActionTracker
  module Templates
    class Update < BaseTemplate
      def event_name
        'Updated'
      end

      def content
        @changes ||= ModelAuditor::Changes.new(target).filter(skipped_attributes).audit
      end

      private

      def skipped_attributes
        options[:skip] || []
      end
    end
  end
end
