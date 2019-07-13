# frozen_string_literal: true

module ActionTracker
  module Templates
    class BaseTemplate
      attr_reader :target, :options

      def initialize(target, options = {})
        @target = target
        @options = options
      end

      def form
        @form ||= ActionTracker::Models::TransitionRecord.new(payload: payload).with_target(target)
      end

      protected

      def payload
        @payload ||= build_payload
      end

      def build_payload
        payload_instance = ActionTracker::Models::Payload.new
        payload_instance.with_user(user).with_content(content).for_event(event_name)
      end

      def user
        @user ||= options[:user] || OpenStruct.new(id: 0, name: 'Anonymous', type: 'System')
      end

      def content
        # Override
      end

      def event_name
        # Override
      end
    end
  end
end
