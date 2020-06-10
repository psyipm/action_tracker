# frozen_string_literal :true

module ActionTracker
  module Models
    class User < ActionTracker::Models::ApplicationRecord
      attribute :id, String
      attribute :name, String
      attribute :type, String

      validates :id, :name, :type, presence: true

      def self.default_user
        new(id: 0, name: 'Anonymous', type: 'System')
      end
    end
  end
end
