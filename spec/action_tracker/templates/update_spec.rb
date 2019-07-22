# frozen_string_literal: true

require 'spec_helper'
require 'support/test_order_shared_context'

RSpec.describe ActionTracker::Templates::Update do
  include_context 'test_order'

  let(:user) { OpenStruct.new(id: 1, name: 'TestUser', type: 'User') }

  let(:template) { described_class.new(order, user: user) }
  let(:form) { template.form }

  it 'should fill event name and inspect changes' do
    allow(order).to receive(:previous_changes).and_return(order_changes)

    expect(form.event).to eq 'Updated'
    expect(form.content).to match(/title[\W]+#{order.title}/)
  end
end
