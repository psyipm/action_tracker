# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::SignedRequest do
  let(:url) { 'https://test.com/api/v1' }

  let(:headers_stub) do
    {
      'X-Access-Key' => 'test-api-key',
      'X-Signature' => Regexp.new('[\w\W]+'),
      'X-Timestamp' => Regexp.new('[\d]+')
    }
  end

  let!(:request_stub) do
    stub_request(:post, url)
      .with(headers: headers_stub)
      .to_return(status: 201, body: '', headers: {})
  end

  it 'should perform request with signature' do
    described_class.new(:post, url).perform

    expect(request_stub).to have_been_requested.once
  end
end
