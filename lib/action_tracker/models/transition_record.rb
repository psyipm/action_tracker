# frozen_string_literal: true

module ActionTracker
  module Models
    class TransitionRecord < ActionTracker::Models::ApplicationRecord
      mimic 'transition'

      attribute :target_id, Integer
      attribute :target_type, String
      attribute :created_at, DateTime
      attribute :payload, ActionTracker::Models::Payload

      delegate :event, :content, :user, to: :payload

      validate :check_payload

      def with_target(target)
        self.target_id = target.id
        self.target_type = target.try(:type) || target.class.name

        self
      end

      def index(params = {})
        path = [collection_path, params.to_query].reject(&:blank?).compact.join('?')
        @response ||= Connection.new.get(path)

        ActionTracker::CollectionProxy.new @response, self.class.model_name
      end

      def collection_path
        'transitions'
      end

      def payload
        super.presence || @payload = ActionTracker::Models::Payload.new
      end

      def attributes
        super.merge(payload: payload.attributes.except(:id))
      end

      def title
        [event, content].reject(&:blank?).compact.join(': ')
      end

      private

      def check_payload
        return if payload.valid?

        errors.add(:payload, :invalid)
      end
    end
  end
end
