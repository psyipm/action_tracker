# frozen_string_literal: true

require 'virtus'
require 'active_model/naming'

module ActionTracker
  module Models
    class ApplicationRecord
      include Virtus.model
      attribute :id, Integer

      def self.mimic(model_name)
        @model_name = model_name.to_s.underscore.to_sym
      end

      def self.mimicked_model_name
        @model_name || infer_model_name
      end

      def self.infer_model_name
        class_name = name.split("::").last
        return :form if class_name == "Form"

        class_name.chomp("Form").underscore.to_sym
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, mimicked_model_name.to_s.camelize)
      end
    end
  end
end
