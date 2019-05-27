# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Config do
  let(:config) { ActionTracker.config }
  let(:client) { config.client }

  it 'should raise error if not configured' do
    expect { config.api_url }.to raise_error(ActionTracker::ClientNotConfiguredError)
    expect { config.api_key }.to raise_error(ActionTracker::ClientNotConfiguredError)
    expect { config.api_secret }.to raise_error(ActionTracker::ClientNotConfiguredError)
  end

  it 'should not raise if config present' do
    ActionTracker.configure do |c|
      c.api_url = 'https://action-tracker.example.com/api/v1'
      c.api_key = 'api-key'
      c.api_secret = 'api-secret'
    end

    expect(config.api_url).to_not be_nil
    expect(config.api_key).to eq 'api-key'
    expect(config.api_secret).to eq 'api-secret'

    expect(client.access_key).to eq 'api-key'
    expect(client.secret).to eq 'api-secret'
  end
end
