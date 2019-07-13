# frozen_string_literal: true

module ActionTracker
  module Templates
    class Destroy < BaseTemplate
      def payload
        super.for_event('Deleted')
      end
    end
  end
end
