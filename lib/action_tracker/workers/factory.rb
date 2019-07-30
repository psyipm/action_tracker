# frozen_string_literal: true

module ActionTracker
  module Workers
    class UndefinedWorkerError < StandardError; end

    class Factory
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def instance
        raise UndefinedWorkerError, tracking_method unless worker_klass

        worker_klass.new(form)
      end

      private

      def worker_klass
        @worker_klass ||= "ActionTracker::Workers::#{tracking_method.classify}".safe_constantize
      end

      def tracking_method
        ActionTracker.config.tracking_method.to_s
      end
    end
  end
end
