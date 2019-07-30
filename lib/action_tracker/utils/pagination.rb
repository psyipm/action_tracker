# frozen_string_literal: true

module ActionTracker
  module Pagination
    delegate :cursor, to: :meta

    def size
      raw_data.try(:size)
    end

    def last_page?
      cursor.blank?
    end
  end
end
