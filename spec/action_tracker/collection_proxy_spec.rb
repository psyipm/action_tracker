# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::CollectionProxy do
  let(:response_body) { File.read('spec/stubs/get_transitions_body.json') }
  let(:data) { JSON.parse response_body }
  let(:model_klass) { ActionTracker::Models::TransitionRecord }

  let(:collection) { described_class.new data, model_klass.model_name }

  let(:transition) { collection.first }

  it 'should behave like collection' do
    expect(collection).to respond_to(:each)
    expect(collection.count).to be_positive
  end

  it 'should parse each item to model' do
    expect(transition.is_a? model_klass).to eq true

    expect(transition.payload).to_not be_nil
    expect(transition.id).to_not be_nil
    expect(transition.content).to_not be_nil
    expect(transition.target_id).to_not be_nil
  end
end
