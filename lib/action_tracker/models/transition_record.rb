# frozen_string_literal: true

module ActionTracker
  module Models
    class TransitionRecord < ActionTracker::Models::ApplicationRecord
      include ActionTracker::HttpGateway

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
        parse_response request(processed_path(collection_path, params))
      end

      def filtered_by_users(params = {})
        path = processed_path(users(params[:user_id]), params.except(:user_id))

        parse_response request(path)
      end

      def filtered_by_users_count(params = {})
        path = processed_path(users(params[:user_id]) + '/count', params.except(:user_id))

        request(path)
      end

      def filtered_by_users_simple_count(params = {})
        path = processed_path(users(params[:user_id]) + '/without_lambda_count', params.except(:user_id))

        request(path)
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

      def collection_path
        'transitions'
      end

      def users(user_id)
        "users/#{user_id}"
      end

      private

      def check_payload
        return if payload.valid?

        errors.add(:payload, :invalid)
      end
    end
  end
end
