require 'spec_helper'

module BugReport496
  class BaseClass
  end

  class SubClass < BaseClass
  end

  describe "a message expectation on a base class object" do
    it "should correctly pick up message sent to it subclass" do
      BaseClass.should_receive(:new).once
      SubClass.new
    end
  end
end

