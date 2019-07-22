# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Templates::BaseTemplate do
  let(:order) { OpenStruct.new(id: 1, price: 100, title: 'Some test order') }
  let(:user) { OpenStruct.new(id: 1, name: 'TestUser', type: 'User') }

  it 'should build transition form' do
    template = described_class.new(order)
    form = template.form

    expect(form.target_id).to eq order.id
    expect(form.target_type).to eq order.class.name
    expect(form.payload.user.id).to eq 0
    expect(form.payload.user.name).to eq 'Anonymous'
  end

  it 'should build form with user' do
    template = described_class.new(order, user: user)
    form = template.form

    expect(form.payload.user.id).to eq user.id
    expect(form.payload.user.name).to eq user.name
    expect(form.payload.user.type).to eq user.type
  end
end
