# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Templates::Update do
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

  let(:order_changes) { { title: [] } }

  let(:order) do
    TestOrder.new(
      id: 1, price: 100, title: 'Some test order', created_at: 30.minutes.ago, updated_at: 5.minutes.ago
    )
  end

  let(:user) { OpenStruct.new(id: 1, name: 'TestUser', type: 'User') }

  let(:template) { described_class.new(order, user: user) }
  let(:form) { template.form }

  it 'should fill event name and inspect changes' do
    allow(order).to receive(:previous_changes).and_return(order_changes)

    expect(form.event).to eq 'Updated'
    expect(form.content).to match %r{title[\W]+#{order.title}}
  end
end
