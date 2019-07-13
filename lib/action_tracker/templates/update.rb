# frozen_string_literal: true

module ActionTracker
  module Templates
    class Update < BaseTemplate
      def payload
        super.for_event('Updated').with_content(changes)
      end

      private

      def changes
        @changes ||= ModelAuditor::Changes.new(target).filter(skipped_attributes).audit
      end

      def skipped_attributes
        options[:skip] || []
      end
    end
  end
end
