# frozen_string_literal :true

module ActionTracker
  module Models
    class Reference < ActionTracker::Models::ApplicationRecord
      attribute :id, Integer
      attribute :type, String
    end
  end
end
