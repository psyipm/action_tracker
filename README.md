# ActionTracker

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
  after_update -> { ActionTracker::Recorder.new(:update).call(self) }
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

# Call recorder
ActionTracker::Recorder.new(:state_change).call(target)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/action_tracker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
