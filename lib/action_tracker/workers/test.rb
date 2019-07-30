# frozen_string_literal: true

module ActionTracker
  module Workers
    class Test
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def perform
        ActionTracker.records.append(params)

        params
      end

      private

      def params
        form.present_attributes
      end
    end
  end
end
