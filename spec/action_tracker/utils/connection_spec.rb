# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Connection do
  let(:connection) { described_class.new }

  def request_stub(type)
    stub_request(type, Regexp.new('/api/v1/transitions'))
      .with(body: hash_including('params' => 'test'))
  end

  def users_request_stub
    stub_request(:get, Regexp.new('/api/v1/users'))
      .with(body: hash_including('params' => 'test'))
  end

  [:get, :post, :put, :patch, :delete].each do |request_method|
    it "should perform `#{request_method}` request" do
      stub = request_stub(request_method)

      connection.send(request_method, 'transitions', body: { params: :test })

      expect(stub).to have_been_requested.once
    end
  end

  it 'should perform get request to users' do
    stub = users_request_stub

    connection.send(:get, 'users/1', body: { params: :test })

    expect(stub).to have_been_requested.once
  end
end
