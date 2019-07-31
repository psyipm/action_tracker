# frozen_string_literal: true

module ActionTracker
  class RecordsCollection < Array
    def select_by(path, value)
      keys = path.to_s.split('.').map(&:to_sym)

      items = select do |item|
        item.dig(*keys) == value
      end

      self.class.new items
    end

    def last_event
      last.dig(:payload, :event)
    end

    def last_content
      last.dig(:payload, :content)
    end
  end
end
