# frozen_string_literal: true

require 'action_tracker/version'
require 'ostruct'
require 'model_auditor'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object'

module ActionTracker
  autoload :Config, 'action_tracker/config'
  autoload :SignedRequest, 'action_tracker/signed_request'
  autoload :Connection, 'action_tracker/connection'

  autoload :Pagination, 'action_tracker/pagination'
  autoload :CollectionProxy, 'action_tracker/collection_proxy'

  autoload :Recorder, 'action_tracker/recorder'

  module Models
    autoload :ApplicationRecord, 'action_tracker/models/application_record'
    autoload :TransitionRecord, 'action_tracker/models/transition_record'
    autoload :Payload, 'action_tracker/models/payload'
    autoload :User, 'action_tracker/models/user'
  end

  module Templates
    autoload :BaseTemplate, 'action_tracker/templates/base_template'
    autoload :Create, 'action_tracker/templates/create'
    autoload :Update, 'action_tracker/templates/update'
    autoload :Destroy, 'action_tracker/templates/destroy'
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
end
