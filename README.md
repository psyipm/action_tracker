# ActionTracker

[![Build Status](https://semaphoreci.com/api/v1/ipm/action_tracker/branches/master/badge.svg)](https://semaphoreci.com/ipm/action_tracker)
[![Maintainability](https://api.codeclimate.com/v1/badges/cfdcabfc3610c6eac895/maintainability)](https://codeclimate.com/github/psyipm/action_tracker/maintainability)
[![Gem Version](https://badge.fury.io/rb/action_tracker_client.svg)](https://badge.fury.io/rb/action_tracker_client)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_tracker_client', require: 'action_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_tracker

## Usage

### Configuration

You need to put the following values in initializer:

```ruby
# config/initializers/action_tracker.rb

ActionTracker.configure do |config|
  config.api_url = ENV['ACTION_TRACKING_API_URL']
  config.api_key = ENV['ACTION_TRACKING_API_KEY']
  config.api_secret = ENV['ACTION_TRACKING_API_SECRET']

  # Avalilable options:
  #
  #   :inline (default) -> performs request to external API
  #   :test             -> stores request parameters, can be accessed via ActionTracker.records
  #   :custom           -> calls custom labda
  #
  config.tracking_method = :custom
  config.custom_worker_proc = ->(form) { MyCustomActionTrackingJob.perform_later(form.attributes) }
end
```

### Reading records

```ruby
api = ActionTracker::Models::TransitionRecord.new
data = api.index(target_id: order.id, target_type: 'Order', per_page: 25, cursor: 'Y3VycmVudF9wYWdl')

#<ActionTracker::CollectionProxy:0x00007f958b6970a8
# ...

data.each do |record|
  puts record.inspect
end

#<ActionTracker::Models::TransitionRecord:0x00007f9584d44470 @id="a51b2fe2-fa92-4e91-bdcd-5beee9081903"...
#<ActionTracker::Models::TransitionRecord:0x00007f9584d3dfd0 @id="810b900d-d24b-4206-85e3-b7a53e55a060"...
```

### Records filtered by user
```ruby
api = ActionTracker::Models::TransitionRecord.new
data = api.filtered_by_users(user_id: user.id, target_id: order.id, target_type: 'Order', per_page: 25, cursor: 'Y3VycmVudF9wYWdl')

#<ActionTracker::CollectionProxy:0x00007f958b6970a8
# ...

data.each do |record|
  puts record.inspect
end

#<ActionTracker::Models::TransitionRecord:0x00007f9584d44470 @id="a51b2fe2-fa92-4e91-bdcd-5beee9081903"...
#<ActionTracker::Models::TransitionRecord:0x00007f9584d3dfd0 @id="810b900d-d24b-4206-85e3-b7a53e55a060"...

# data = api.filtered_by_users_count(user_id: user.id, target_id: order.id, target_type: 'Order')
# this will return count of actions 
```

### Writing records

Call ActionTracker::Recorder after creating or updating your model:

basic usage: `ActionTracker::Recorder.new(:event_name).call(model)`

Where :event_name is the name of template. Custom templates could be defined if needed.

valid events (templates): `[:create, :update, :destroy]`

```ruby
  # Suppose you have some command, creating an order:

  class CreateOrderCommand
    # https://github.com/krisleech/wisper
    include Wisper::Publisher

    def initialize(order_form)
      @form = order_form

      subscribe(ActionTracker::Recorder.new(:create), on: :ok, with: :call)
    end

    def call
      if order.save
        broadcast(:ok, order)
      else
        broadcast(:failed, order)
      end
    end
  end
```

or with ActiveRecord callbacks:

```ruby
class User < ApplicationRecord
  SKIPPED_ATTRIBUTES = [:password, :updated_at]

  after_update -> { ActionTracker::Recorder.new(:update, skip: SKIPPED_ATTRIBUTES).call(self) }
end
```

### Defining custom templates

Action tracker will look for templates in ActionTracker::Templates module.

```ruby
# app/models/action_tracker/templates/state_change.rb

module ActionTracker
  module Templates
    class StateChange < ActionTracker::Templates::BaseTemplate

      # Any text, describing the event
      #
      def event_name
        'State changed'
      end

      # Can be any string, representing what changed in your model. Max length limited to 1000 chars
      #
      def content
        "from `#{target.previous_state_name}` to `#{target.current_state_name}`"
      end

      # The user who performed the change. { id: 0, name: 'Anonymous', type: 'System' }
      #
      def user
        @user ||= CurrentUser.fetch
      end
    end
  end
end

module ActionTracker
  module Templates
    module Orders
      class SomeCustomEvent < ActionTracker::Templates::BaseTemplate
        # ...
      end
    end
  end
end

# Call recorder
ActionTracker::Recorder.new(:state_change).call(target)
ActionTracker::Recorder.new('Orders::SomeCustomEvent').call(target)
```

## Testing

Set tracking method to `:test` in application environment config and clear records after each spec

```ruby
  # config/environments/test.rb

  config.after_initialize do
    ActionTracker.config.tracking_method = :test
  end

  # spec/rails_helper.rb

  config.after(:each) do
    ActionTracker.clear_records
  end
```

```ruby
  ActionTracker.records

  => [{:target_id=>76, :target_type=>"Order", :payload=>{:event=>"Created payment #89", :content=>"amount 100.0", :user=>{:id=>0, :name=>"Anonymous", :type=>"System"}}, :reference_id=>89, :reference_type=>"PaymentTransaction"}]

  ActionTracker.last_event

  => "Created payment #89"

  ActionTracker.records.select_by('payload.user.name', 'Anonymous')

  => [{:target_id=>76, :target_type=>"Order".....

  ActionTracker.records.last_content

  => "amount 100.0"

  ActionTracker.records.select_by('payload.user.name', 'SomeUser')

  => []
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/action_tracker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
