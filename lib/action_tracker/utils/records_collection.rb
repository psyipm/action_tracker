# frozen_string_literal: true

module ActionTracker
  class RecordsCollection < Array
    def select_by(path, value)
      keys = path.to_s.split('.').map(&:to_sym)

      select do |item|
        item.dig(*keys) == value
      end
    end

    def last_event
      last.dig(:payload, :event)
    end
  end
end
