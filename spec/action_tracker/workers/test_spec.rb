# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Workers::Test do
  let(:form) { ActionTracker::Models::TransitionRecord.new(target_id: 1, target_type: 'Test') }

  it 'should store request params' do
    described_class.new(form).perform
    expect(ActionTracker.records.count).to eq 1
    expect(ActionTracker.records.first.dig(:target_type)).to eq form.target_type

    described_class.new(form).perform
    expect(ActionTracker.records.count).to eq 2

    ActionTracker.clear_records
    expect(ActionTracker.records.count).to eq 0
  end

  it 'should return hash' do
    response = described_class.new(form).perform
    expect(response.is_a?(Hash)).to eq true
  end
end
