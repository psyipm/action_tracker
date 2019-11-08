require 'bundler/setup'
require 'action_tracker'
require 'webmock/rspec'

require 'pry-byebug'

RSpec.configure do |config|
  Time.zone = ActiveSupport::TimeZone.all.first
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    ActionTracker.configure do |c|
      c.api_key = 'test-api-key'
      c.api_secret = 'test-api-secret'
      c.api_url = 'https://action-tracker.example.com/api/v1'
    end
  end
end
