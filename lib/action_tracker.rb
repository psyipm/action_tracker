# frozen_string_literal: true

require 'action_tracker/version'
require 'ostruct'

module ActionTracker
  autoload :Config, 'action_tracker/config'

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
end
