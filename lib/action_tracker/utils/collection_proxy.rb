# frozen_string_literal: true

module ActionTracker
  class CollectionProxy
    include Enumerable
    include ActionTracker::Pagination

    attr_reader :model_name

    def initialize(response, model_name)
      @response = response
      @model_name = model_name
    end

    def code
      @response.code
    end

    def each
      raw_data.each do |record|
        yield record_klass.new(record)
      end
    end

    def raw_data
      @response.dig(model_name.plural)
    end

    def entry_name(options = {})
      model_name.singular.pluralize(options[:count])
    end

    private

    def meta
      OpenStruct.new(@response.dig('meta'))
    end

    def record_klass
      model_name.instance_variable_get(:@klass)
    end
  end
end
