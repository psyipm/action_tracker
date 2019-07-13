module ActionTracker
  module Models
    class Payload < ApplicationRecord
      MAX_CONTENT_LENGTH = 1000

      attribute :user_id, Integer
      attribute :user_name, String
      attribute :user_type, String
      attribute :event, String
      attribute :content, String

      def with_user(user)
        self[:user_id] = user&.id
        self[:user_name] = user&.name
        self[:user_type] = user&.type

        self
      end

      def for_event(event)
        self[:event] = event.to_s.humanize
        self
      end

      def with_content(content)
        self[:content] = content.to_s.truncate(MAX_CONTENT_LENGTH)
        self
      end
    end
  end
end
