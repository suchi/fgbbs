require 'spec_helper'

describe Attach do
  before(:each) do
    @valid_attributes = {
      :filename => "value for filename",
      :article_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Attach.create!(@valid_attributes)
  end
end
