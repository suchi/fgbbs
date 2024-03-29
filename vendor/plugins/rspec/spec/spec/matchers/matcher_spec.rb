require 'spec_helper'

class UnexpectedError < StandardError; end

module Spec
  module Matchers
    describe Matcher do
      context "without overrides" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:be_a_multiple_of, 3) do |multiple|
            match do |actual|
              actual % multiple == 0
            end
          end
        end

        it "provides a default description" do
          @matcher.description.should == "be a multiple of 3"
        end

        it "provides a default failure message for #should" do
          @matcher.matches?(8)
          @matcher.failure_message_for_should.should == "expected 8 to be a multiple of 3"
        end

        it "provides a default failure message for #should_not" do
          @matcher.matches?(9)
          @matcher.failure_message_for_should_not.should == "expected 9 not to be a multiple of 3"
        end
      end

      it "is not diffable by default" do
        matcher = Spec::Matchers::Matcher.new(:name) {}
        matcher.should_not be_diffable
      end

      it "is diffable when told to be" do
        matcher = Spec::Matchers::Matcher.new(:name) { diffable }
        matcher.should be_diffable
      end

      it "provides expected" do
        matcher = Spec::Matchers::Matcher.new(:name, 'expected string') {}
        matcher.expected.should == ['expected string']
      end

      it "provides actual" do
        matcher = Spec::Matchers::Matcher.new(:name, 'expected string') do
          match {|actual|}
        end

        matcher.matches?('actual string')

        matcher.actual.should == 'actual string'
      end

      context "wrapping another expectation (should == ...)" do
        it "returns true if the wrapped expectation passes" do
          matcher = Spec::Matchers::Matcher.new(:name, 'value') do |expected|
            match do |actual|
              actual.should == expected
            end
          end
          matcher.matches?('value').should be_true
        end

        it "returns false if the wrapped expectation fails" do
          matcher = Spec::Matchers::Matcher.new(:name, 'value') do |expected|
            match do |actual|
              actual.should == expected
            end
          end
          matcher.matches?('other value').should be_false
        end
      end

      context "with overrides" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:be_boolean, true) do |boolean|
            match do |actual|
              actual
            end
            description do
              "be the boolean #{boolean}"
            end
            failure_message_for_should do |actual|
              "expected #{actual} to be the boolean #{boolean}"
            end
            failure_message_for_should_not do |actual|
              "expected #{actual} not to be the boolean #{boolean}"
            end
          end
        end

        it "does not hide result of match block when true" do
          @matcher.matches?(true).should be_true
        end

        it "does not hide result of match block when false" do
          @matcher.matches?(false).should be_false
        end

        it "overrides the description" do
          @matcher.description.should == "be the boolean true"
        end

        it "overrides the failure message for #should" do
          @matcher.matches?(false)
          @matcher.failure_message_for_should.should == "expected false to be the boolean true"
        end

        it "overrides the failure message for #should_not" do
          @matcher.matches?(true)
          @matcher.failure_message_for_should_not.should == "expected true not to be the boolean true"
        end
      end

      context "#new" do
        it "passes matches? arg to match block" do
          matcher = Spec::Matchers::Matcher.new(:ignore) do
            match do |actual|
              actual == 5
            end
          end
          matcher.matches?(5).should be_true
        end

        it "exposes arg submitted through #new to matcher block" do
          matcher = Spec::Matchers::Matcher.new(:ignore, 4) do |expected|
            match do |actual|
              actual > expected
            end
          end
          matcher.matches?(5).should be_true
        end
      end

      context "with no args" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:matcher_name) do
            match do |actual|
              actual == 5
            end
          end
        end

        it "matches" do
          @matcher.matches?(5).should be_true
        end

        it "describes" do
          @matcher.description.should == "matcher name"
        end
      end

      context "with 1 arg" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:matcher_name, 1) do |expected|
            match do |actual|
              actual == 5 && expected == 1
            end
          end
        end

        it "matches" do
          @matcher.matches?(5).should be_true
        end

        it "describes" do
          @matcher.description.should == "matcher name 1"
        end
      end

      context "with multiple args" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:matcher_name, 1, 2, 3, 4) do |a,b,c,d|
            match do |sum|
              a + b + c + d == sum
            end
          end
        end

        it "matches" do
          @matcher.matches?(10).should be_true
        end

        it "describes" do
          @matcher.description.should == "matcher name 1, 2, 3, and 4"
        end
      end

      it "supports helper methods" do
        matcher = Spec::Matchers::Matcher.new(:be_similar_to, [1,2,3]) do |sample|
          match do |actual|
            similar?(sample, actual)
          end

          def similar?(a, b)
            a.sort == b.sort
          end
        end

        matcher.matches?([2,3,1]).should be_true
      end

      it "supports fluent interface" do
        matcher = Spec::Matchers::Matcher.new(:first_word) do
          def second_word
            self
          end
        end

        matcher.second_word.should == matcher
      end

      it "treats method missing normally for undeclared methods" do
        matcher = Spec::Matchers::Matcher.new(:ignore) { }
        expect { matcher.non_existent_method }.to raise_error(NoMethodError)
      end

      it "has access to other matchers" do
        matcher = Spec::Matchers::Matcher.new(:ignore, 3) do |expected|
          match do |actual|
            extend Spec::Matchers
            actual.should eql(5 + expected)
          end
        end

        matcher.matches?(8).should be_true
      end

      describe "#match_unless_raises" do
        context "with a passing assertion" do
          let(:mod) do
            Module.new do
              def assert_equal(a,b)
                a == b ? nil : (raise UnexpectedError.new("#{a} does not equal #{b}"))
              end
            end
          end
          let(:matcher) do
            m = mod
            Spec::Matchers::Matcher.new :equal, 4 do |expected|
              extend m
              match_unless_raises UnexpectedError do
                assert_equal expected, actual
              end
            end
          end
          it "passes as you would expect" do
            matcher.matches?(4).should be_true
          end
          it "fails as you would expect" do
            matcher.matches?(5).should be_false
          end
        end

        context "with an unexpected error" do
          let(:matcher) do
            Spec::Matchers::Matcher.new :foo, :bar do |expected|
              match_unless_raises SyntaxError do |actual|
                raise "unexpected exception"
              end
            end
          end

          it "raises the error" do
            expect do
              matcher.matches?(:bar)
            end.to raise_error("unexpected exception")
          end
        end

      end

      it "can define chainable methods" do
        matcher = Spec::Matchers::Matcher.new(:name) do
          chain(:expecting) do |expected_value|
            @expected_value = expected_value
          end
          match { |actual| actual == @expected_value }
        end

        matcher.expecting('value').matches?('value').should be_true
        matcher.expecting('value').matches?('other value').should be_false
      end
    end
  end
end
