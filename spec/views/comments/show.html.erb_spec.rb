require 'spec_helper'


describe "/comments/show.html.erb" do
  include CommentsHelper
  before(:each) do
    assigns[:comment] = @comment = stub_model(Comment,

      :body => "value for body",

      :user => "value for user",

      :article_id => 1


    )

  end

  it "renders attributes in <p>" do
    render

    response.should have_text(/value\ for\ body/)

    response.should have_text(/value\ for\ user/)

    response.should have_text(/1/)

  end
end
