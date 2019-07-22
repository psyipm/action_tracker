# frozen_string_literal: true

RSpec.shared_context 'test_order', shared_context: :metadata do
  class TestOrder < OpenStruct
    def self.human_attribute_name(key)
      key
    end

    def persisted?
      true
    end

    def destroyed?
      false
    end
  end

  let(:order_changes) { { title: ['value', order.title] } }

  let(:order) do
    TestOrder.new(
      id: 1, price: 100, title: 'Some test order', created_at: 30.minutes.ago, updated_at: 5.minutes.ago
    )
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'test_order', include_shared: true
end
