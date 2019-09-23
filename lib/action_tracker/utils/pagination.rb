# frozen_string_literal: true

module ActionTracker
  module Pagination
    delegate :next_cursor, :current_cursor, to: :meta

    def size
      raw_data.try(:size)
    end

    def per_page
      meta.per_page.to_i
    end

    def last_page?
      next_cursor.blank?
    end

    def first_page?
      current_cursor.blank?
    end
  end
end
