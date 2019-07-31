# frozen_string_literal: true

module ActionTracker
  class UndefinedTemplateError < StandardError; end
  class EmptyTargetError < StandardError; end

  # Usage:
  #   ActionTracker::Recorder.new(:create).call(order)
  #
  #   usage with wisper gem: (https://github.com/krisleech/wisper)
  #
  #   MyPublisher.suscribe(ActionTracker::Recorder.new(:update), on: :ok, with: :call)
  #
  class Recorder
    attr_reader :options

    def initialize(template_name, template_options = {})
      @template_name = template_name
      @options = template_options
    end

    def call(target)
      form = template_klass.new(target, options).form
      return unless form.valid?
      raise EmptyTargetError, inspect unless target

      @response = ActionTracker::Workers::Factory.new(form).instance.perform
      @response.to_h
    end

    private

    def template_name
      @template_name.to_s.classify
    end

    def template_klass
      klass = "ActionTracker::Templates::#{template_name}".safe_constantize
      raise UndefinedTemplateError, template_name unless klass

      klass
    end
  end
end
