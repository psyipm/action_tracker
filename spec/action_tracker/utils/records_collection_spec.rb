# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::RecordsCollection do
  let(:collection) { described_class.new }
  let(:form) { ActionTracker::Models::TransitionRecord.new }

  it 'should find last_event' do
    collection.append(form.present_attributes)
    form.payload.event = 'test_event'
    collection.append(form.present_attributes)

    expect(collection.last_event).to eq 'test_event'
  end

  it 'should filter items' do
    collection.append(form.attributes)
    form.payload.event = 'test_event'
    collection.append(form.attributes)

    items = collection.select_by('payload.event', 'test_event')

    expect(items.size).to eq 1
    expect(items.last.dig(:payload, :event)).to eq 'test_event'
  end
end
