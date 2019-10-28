# frozen_string_literal: true

module ActionTracker
  module Models
    class TransitionRecord < ActionTracker::Models::ApplicationRecord
      mimic 'transition'

      attribute :target_id, Integer
      attribute :target_type, String
      attribute :created_at, DateTime
      attribute :payload, ActionTracker::Models::Payload
      attribute :reference_id, Integer
      attribute :reference_type, String

      delegate :event, :content, :user, to: :payload

      validate :check_payload

      def with_target(target)
        self.target_id = target.try(:id)
        self.target_type = target.try(:type) || target.class.name

        self
      end

      def reference=(item)
        return unless item

        self[:reference_id] = item.try(:id)
        self[:reference_type] = item.try(:type) || item.class.name
      end

      def index(params = {})
        @path = processed_path(collection_path, params)

        parse_response
      end

      def filtered_by_users(params = {})
        @path = processed_path(users(params[:user_id]), params.except(:user_id))

        parse_response
      end

      def filtered_by_users_count(params = {})
        @path = processed_path(users(params[:user_id]) + '/count', params.except(:user_id))

        response
      end

      def collection_path
        'transitions'
      end

      def users(user_id)
        "users/#{user_id}"
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

      def parse_response
        ActionTracker::CollectionProxy.new response, self.class.model_name
      end

      def response
        @response ||= Connection.new.get(@path)
      end

      def check_payload
        return if payload.valid?

        errors.add(:payload, :invalid)
      end

      def processed_path(collection_name, params)
        [collection_name, params.to_query].reject(&:blank?).compact.join('?')
      end
    end
  end
end
