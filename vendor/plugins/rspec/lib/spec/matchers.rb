require 'spec/extensions/instance_exec'
require 'spec/matchers/pretty'
require 'spec/matchers/matcher'
require 'spec/matchers/operator_matcher'
require 'spec/matchers/be'
require 'spec/matchers/be_close'
require 'spec/matchers/be_instance_of'
require 'spec/matchers/be_kind_of'
require 'spec/matchers/change'
require 'spec/matchers/eql'
require 'spec/matchers/equal'
require 'spec/matchers/errors'
require 'spec/matchers/exist'
require 'spec/matchers/generated_descriptions'
require 'spec/matchers/has'
require 'spec/matchers/have'
require 'spec/matchers/include'
require 'spec/matchers/match'
require 'spec/matchers/match_array'
require 'spec/matchers/method_missing'
require 'spec/matchers/raise_exception'
require 'spec/matchers/respond_to'
require 'spec/matchers/satisfy'
require 'spec/matchers/simple_matcher'
require 'spec/matchers/throw_symbol'
require 'spec/matchers/wrap_expectation'
require 'spec/matchers/compatibility'
require 'spec/matchers/dsl'

module Spec

  # RSpec ships with a number of useful Expression Matchers. An Expression Matcher
  # is any object that responds to the following methods:
  #
  #   matches?(actual)
  #   failure_message_for_should
  #
  # These methods are also part of the matcher protocol, but are optional:
  #
  #   does_not_match?(actual)
  #   failure_message_for_should_not
  #   description #optional
  #
  # These methods are from older versions of the protocol. They are still supported,
  # but are not recommended:
  #
  #   failure_message          (use failure_message_for_should instead)
  #   negative_failure_message (use failure_message_for_should_not instead)
  #
  # See Spec::Expectations to learn how to use these as Expectation Matchers.
  #
  # == Predicates
  #
  # In addition to those Expression Matchers that are defined explicitly, RSpec will
  # create custom Matchers on the fly for any arbitrary predicate, giving your specs
  # a much more natural language feel. 
  #
  # A Ruby predicate is a method that ends with a "?" and returns true or false.
  # Common examples are +empty?+, +nil?+, and +instance_of?+.
  #
  # All you need to do is write +should be_+ followed by the predicate without
  # the question mark, and RSpec will figure it out from there. For example:
  #
  #   [].should be_empty => [].empty? #passes
  #   [].should_not be_empty => [].empty? #fails
  #
  # In addtion to prefixing the predicate matchers with "be_", you can also use "be_a_"
  # and "be_an_", making your specs read much more naturally:
  #
  #   "a string".should be_an_instance_of(String) =>"a string".instance_of?(String) #passes
  #
  #   3.should be_a_kind_of(Fixnum) => 3.kind_of?(Numeric) #passes
  #   3.should be_a_kind_of(Numeric) => 3.kind_of?(Numeric) #passes
  #   3.should be_an_instance_of(Fixnum) => 3.instance_of?(Fixnum) #passes
  #   3.should_not be_instance_of(Numeric) => 3.instance_of?(Numeric) #fails
  #
  # RSpec will also create custom matchers for predicates like +has_key?+. To
  # use this feature, just state that the object should have_key(:key) and RSpec will
  # call has_key?(:key) on the target. For example:
  #
  #   {:a => "A"}.should have_key(:a) => {:a => "A"}.has_key?(:a) #passes
  #   {:a => "A"}.should have_key(:b) => {:a => "A"}.has_key?(:b) #fails
  #
  # You can use this feature to invoke any predicate that begins with "has_", whether it is
  # part of the Ruby libraries (like +Hash#has_key?+) or a method you wrote on your own class.
  #
  # == Custom Matchers
  #
  # When you find that none of the stock Expectation Matchers provide a natural
  # feeling expectation, you can very easily write your own using RSpec's matcher
  # DSL or writing one from scratch.
  #
  # === Matcher DSL
  #
  # Imagine that you are writing a game in which players can be in various
  # zones on a virtual board. To specify that bob should be in zone 4, you
  # could say:
  #
  #   bob.current_zone.should eql(Zone.new("4"))
  #
  # But you might find it more expressive to say:
  #
  #   bob.should be_in_zone("4")
  #
  # and/or
  #
  #   bob.should_not be_in_zone("3")
  #
  # You can create such a matcher like so:
  #
  #   Spec::Matchers.define :be_in_zone do |zone|
  #     match do |player|
  #       player.in_zone?(zone)
  #     end
  #   end
  #
  # This will generate a <tt>be_in_zone</tt> method that returns a matcher
  # with logical default messages for failures. You can override the failure
  # messages and the generated description as follows:
  #
  #   Spec::Matchers.define :be_in_zone do |zone|
  #     match do |player|
  #       player.in_zone?(zone)
  #     end
  #     failure_message_for_should do |player|
  #       # generate and return the appropriate string.
  #     end
  #     failure_message_for_should_not do |player|
  #       # generate and return the appropriate string.
  #     end
  #     description do
  #       # generate and return the appropriate string.
  #     end
  #   end
  #
  # Each of the message-generation methods has access to the block arguments
  # passed to the <tt>create</tt> method (in this case, <tt>zone</tt>). The
  # failure message methods (<tt>failure_message_for_should</tt> and
  # <tt>failure_message_for_should_not</tt>) are passed the actual value (the
  # receiver of <tt>should</tt> or <tt>should_not</tt>).
  #
  # You can also create matchers that obey a fluent interface using the
  # <tt>chain</tt> method:
  #
  #   Spec::Matchers.define :tip do |expected_tip|
  #     chain :on do |bill|
  #       @bill = bill
  #     end
  #
  #     match do |person|
  #       person.tip_for(bill) == expected_tip
  #     end
  #   end
  #
  # This matcher can be used as follows:
  #
  #   describe Customer do
  #     it { should tip(10).on(50) }
  #   end
  #
  # === Custom Matcher from scratch
  #
  # You could also write a custom matcher from scratch, as follows:
  #
  #   class BeInZone
  #     def initialize(expected)
  #       @expected = expected
  #     end
  #     def matches?(target)
  #       @target = target
  #       @target.current_zone.eql?(Zone.new(@expected))
  #     end
  #     def failure_message_for_should
  #       "expected #{@target.inspect} to be in Zone #{@expected}"
  #     end
  #     def failure_message_for_should_not
  #       "expected #{@target.inspect} not to be in Zone #{@expected}"
  #     end
  #   end
  #
  # ... and a method like this:
  #
  #   def be_in_zone(expected)
  #     BeInZone.new(expected)
  #   end
  #
  # And then expose the method to your specs. This is normally done
  # by including the method and the class in a module, which is then
  # included in your spec:
  #
  #   module CustomGameMatchers
  #     class BeInZone
  #       ...
  #     end
  #
  #     def be_in_zone(expected)
  #       ...
  #     end
  #   end
  #
  #   describe "Player behaviour" do
  #     include CustomGameMatchers
  #     ...
  #   end
  #
  # or you can include in globally in a spec_helper.rb file <tt>require</tt>d
  # from your spec file(s):
  #
  #   Spec::Runner.configure do |config|
  #     config.include(CustomGameMatchers)
  #   end
  #
  module Matchers; end
end
