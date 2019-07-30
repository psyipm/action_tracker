# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActionTracker::Workers::Factory do
  let(:form) { ActionTracker::Models::TransitionRecord.new }

  ActionTracker::Config::VALID_TRACKING_METHODS.each do |tracking_method|
    it "should build `#{tracking_method}` worker class" do
      expect(ActionTracker.config)
        .to receive(:tracking_method).and_return(tracking_method)

      expect(described_class.new(form).instance.class.name)
        .to eq "ActionTracker::Workers::#{tracking_method.to_s.classify}"
    end
  end
end
