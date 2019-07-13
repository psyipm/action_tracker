# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Recorder do
  let(:response_body) { File.read('spec/stubs/transition_created_body.json') }

  let!(:create_transition_stub) do
    stub_request(:post, Regexp.new('/api/v1/transitions'))
      .to_return(status: 201, body: response_body, headers: { content_type: 'application/json' })
  end

  let(:order) { OpenStruct.new(id: 1, title: 'some_test_order') }

  [:create, :update, :destroy].each do |template_name|
    it "should build `#{template_name}` form and perform API call" do
      allow(order).to receive(:previous_changes).and_return({})

      recorder = described_class.new(template_name)

      recorder.call(order)

      expect(create_transition_stub).to have_been_requested.once
    end
  end
end
