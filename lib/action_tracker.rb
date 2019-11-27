# frozen_string_literal: true

require 'action_tracker/version'
require 'ostruct'
require 'model_auditor'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object'

module ActionTracker
  autoload :Config, 'action_tracker/config'
  autoload :Recorder, 'action_tracker/recorder'

  autoload :CollectionProxy, 'action_tracker/utils/collection_proxy'
  autoload :Connection, 'action_tracker/utils/connection'
  autoload :Pagination, 'action_tracker/utils/pagination'
  autoload :RecordsCollection, 'action_tracker/utils/records_collection'
  autoload :SignedRequest, 'action_tracker/utils/signed_request'
  autoload :HttpGateway, 'action_tracker/utils/http_gateway'

  module Models
    autoload :ApplicationRecord, 'action_tracker/models/application_record'
    autoload :TransitionRecord, 'action_tracker/models/transition_record'
    autoload :StatisticRecord, 'action_tracker/models/statistic_record'
    autoload :Payload, 'action_tracker/models/payload'
    autoload :User, 'action_tracker/models/user'
  end

  module Templates
    autoload :BaseTemplate, 'action_tracker/templates/base_template'
    autoload :Create, 'action_tracker/templates/create'
    autoload :Update, 'action_tracker/templates/update'
    autoload :Destroy, 'action_tracker/templates/destroy'
  end

  module Workers
    autoload :Factory, 'action_tracker/workers/factory'
    autoload :Inline, 'action_tracker/workers/inline'
    autoload :Custom, 'action_tracker/workers/custom'
    autoload :Test, 'action_tracker/workers/test'
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end

  def self.last_event
    records.last_event
  end

  def self.records
    @records || clear_records
  end

  def self.clear_records
    @records = ActionTracker::RecordsCollection.new
  end
end
