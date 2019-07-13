# frozen_string_literal: true

module ActionTracker
  module Pagination
    delegate :current_page, :next_page, :prev_page, :total_pages, :total_count, :offset_value, :limit_value,
             to: :meta

    def size
      raw_data.try(:size)
    end

    def last_page?
      current_page == total_pages
    end

    def first_page?
      current_page == 1
    end

    def out_of_range?
      current_page > total_pages
    end
  end
end
