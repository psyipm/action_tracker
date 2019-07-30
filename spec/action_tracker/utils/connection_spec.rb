# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Connection do
  let(:connection) { described_class.new }

  def request_stub(type)
    stub_request(type, Regexp.new('/api/v1/transitions'))
      .with(body: hash_including('params' => 'test'))
  end

  [:get, :post, :put, :patch, :delete].each do |request_method|
    it "should perform `#{request_method}` request" do
      stub = request_stub(request_method)

      connection.send(request_method, 'transitions', body: { params: :test })

      expect(stub).to have_been_requested.once
    end
  end
end
