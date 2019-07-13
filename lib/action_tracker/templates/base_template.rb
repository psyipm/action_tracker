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

      def payload
        @payload ||= ActionTracker::Models::Payload.new.with_user(user)
      end

      def user
        @user ||= options[:user] || OpenStruct.new(id: 0, name: 'Anonymous', type: 'System')
      end
    end
  end
end
