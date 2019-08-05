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
        @form ||= ActionTracker::Models::TransitionRecord.new(
          payload: payload,
          reference: reference
        ).with_target(target)
      end

      protected

      def payload
        @payload ||= build_payload
      end

      def build_payload
        payload_instance = ActionTracker::Models::Payload.new

        payload_instance
          .with_user(user)
          .with_content(content)
          .for_event(event_title)
      end

      def user
        @user ||= options[:user] || ActionTracker::Models::User.default_user
      end

      # Override
      #
      def content
        options[:content] || target.try(:id)
      end

      def event_title
        [title_prepend, event_name, title_append].compact.join(' ').humanize
      end

      def event_name
        # Override
      end

      def title_prepend
        options[:title_prepend]
      end

      def title_append
        options[:title_append]
      end

      def reference
        options[:reference]
      end
    end
  end
end
