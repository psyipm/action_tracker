# frozen_string_literal: true

module ActionTracker
  module Templates
    class Update < BaseTemplate
      def event_name
        'Updated'
      end

      def content
        @content ||= ModelAuditor::Changes.new(inspectable, changes).filter(skipped_attributes).audit
      end

      private

      def inspectable
        options[:reference] || target
      end

      def changes
        options[:changes]
      end

      def skipped_attributes
        options[:skip]
      end
    end
  end
end
