require 'spec_helper'

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :user => "value for user"
    }
  end

  it "should create a new instance given valid attributes" do
    Article.create!(@valid_attributes)
  end
end
