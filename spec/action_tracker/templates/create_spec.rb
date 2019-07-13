# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Templates::Create do
  let(:order) { OpenStruct.new(id: 1, price: 100, title: 'Some test order') }
  let(:user) { OpenStruct.new(id: 1, name: 'TestUser', type: 'User') }

  let(:template) { described_class.new(order, user: user) }
  let(:form) { template.form }

  it 'should fill event name' do
    expect(form.event).to eq 'Created'
  end
end
