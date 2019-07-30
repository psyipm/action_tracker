# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Workers::Custom do
  let(:form) { ActionTracker::Models::TransitionRecord.new(target_id: 1, target_type: 'Test') }

  let(:transition_created_body) { File.read('spec/stubs/transition_created_body.json') }

  let!(:create_transition_stub) do
    stub_request(:post, Regexp.new('/api/v1/transitions'))
      .to_return(status: 200, body: transition_created_body)
  end

  let(:worker) { described_class.new(form) }

  it 'should use inline worker by default' do
    worker.perform

    expect(create_transition_stub).to have_been_requested.once
  end

  it 'should call custom proc' do
    ActionTracker.config.custom_worker_proc = ->(form) { form.target_type }

    expect(worker.perform).to eq form.target_type
    expect(create_transition_stub).to_not have_been_requested
  end
end
