# frozen_string_literal: true

module ActionTracker
  module Templates
    class Create < BaseTemplate
      def payload
        super.for_event('Created')
      end
    end
  end
end
