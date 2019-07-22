# frozen_string_literal: true

require 'spec_helper'
require 'support/test_order_shared_context'

RSpec.describe ActionTracker::Recorder do
  include_context 'test_order'

  let(:response_body) { File.read('spec/stubs/transition_created_body.json') }

  let!(:create_transition_stub) do
    stub_request(:post, Regexp.new('/api/v1/transitions'))
      .to_return(status: 201, body: response_body, headers: { content_type: 'application/json' })
  end

  [:create, :destroy].each do |template_name|
    it "should build `#{template_name}` form and perform API call" do
      recorder = described_class.new(template_name, content: 'content')

      recorder.call(order)

      expect(create_transition_stub).to have_been_requested.once
    end
  end

  it 'should build `:update` form' do
    allow(order).to receive(:previous_changes).and_return(order_changes)

    described_class.new(:update).call(order)

    expect(create_transition_stub).to have_been_requested.once
  end
end
