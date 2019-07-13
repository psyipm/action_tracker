# frozen_string_literal: true

module ActionTracker
  module Templates
    class Destroy < BaseTemplate
      def event_name
        'Deleted'
      end
    end
  end
end
