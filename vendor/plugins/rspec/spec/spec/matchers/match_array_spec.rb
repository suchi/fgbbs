require 'spec_helper'

class UnsortableObject
  def initialize(id)
    @id = id
  end

  def inspect
    @id.to_s
  end

  def ==(other)
    false
  end
end

describe "array.should =~ other_array" do
  it "should pass if target contains all items" do
    [1,2,3].should =~ [1,2,3]
  end

  it "should pass if target contains all items out of order" do
    [1,3,2].should =~ [1,2,3]
  end

  it "should fail if target includes extra items" do
    lambda {
      [1,2,3,4].should =~ [1,2,3]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 2, 3]
actual collection contained:    [1, 2, 3, 4]
the extra elements were:        [4]
MESSAGE
  end

  it "should fail if target is missing items" do
    lambda {
      [1,2].should =~ [1,2,3]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 2, 3]
actual collection contained:    [1, 2]
the missing elements were:      [3]
MESSAGE
  end

  it "should fail if target is missing items and has extra items" do

    lambda {
      [1,2,4].should =~ [1,2,3]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 2, 3]
actual collection contained:    [1, 2, 4]
the missing elements were:      [3]
the extra elements were:        [4]
MESSAGE
  end

  it "should sort items in the error message if they all respond to <=>" do
    lambda {
      [6,2,1,5].should =~ [4,1,2,3]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 2, 3, 4]
actual collection contained:    [1, 2, 5, 6]
the missing elements were:      [3, 4]
the extra elements were:        [5, 6]
MESSAGE
  end

  it "should not sort items in the error message if they don't all respond to <=>" do
    with_ruby 1.8 do
      lambda {
        [UnsortableObject.new(2), UnsortableObject.new(1)].should =~ [UnsortableObject.new(4), UnsortableObject.new(3)]
      }.should fail_with(<<-MESSAGE)
expected collection contained:  [4, 3]
actual collection contained:    [2, 1]
the missing elements were:      [4, 3]
the extra elements were:        [2, 1]
MESSAGE
    end
  end

  it "should accurately report extra elements when there are duplicates" do
    lambda {
      [1,1,1,5].should =~ [1,5]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 5]
actual collection contained:    [1, 1, 1, 5]
the extra elements were:        [1, 1]
MESSAGE
  end

  it "should accurately report missing elements when there are duplicates" do
    lambda {
      [1,5].should =~ [1,1,5]
    }.should fail_with(<<-MESSAGE)
expected collection contained:  [1, 1, 5]
actual collection contained:    [1, 5]
the missing elements were:      [1]
MESSAGE
  end

  it "should work with subclasses of Array" do
    class SuperArray < Array; end
    SuperArray.new([1,2,3]).should =~ SuperArray.new([3,2,1])
  end

end

describe "should_not =~ [:with, :multiple, :args]" do
  it "should not be supported" do
    lambda {
      [1,2,3].should_not =~ [1,2,3]
    }.should fail_with(/Matcher does not support should_not/)
  end
end
