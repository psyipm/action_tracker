# frozen_string_literal: true

module ActionTracker
  module Models
    class Payload < ActionTracker::Models::ApplicationRecord
      MAX_CONTENT_LENGTH = 1000

      attribute :event, String
      attribute :content, String
      attribute :user, ActionTracker::Models::User
      attribute :reference, ActionTracker::Models::Reference

      validates :event, :content, presence: true

      def with_user(user)
        self[:user] = ActionTracker::Models::User.new(
          id: user.try(:id),
          name: user.try(:name),
          type: user.try(:type)
        )

        self
      end

      def with_reference(item)
        return self unless item

        self[:reference] = ActionTracker::Models::Reference.new(
          id: item.try(:id),
          type: item.class.name
        )

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
