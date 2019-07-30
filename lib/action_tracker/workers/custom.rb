# frozen_string_literal: true

module ActionTracker
  module Workers
    class Custom
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def perform
        custom_worker_proc.call(form)
      end

      private

      def custom_worker_proc
        ActionTracker.config.custom_worker_proc
      end
    end
  end
end
