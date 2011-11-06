require 'spec_helper'


describe "/comments/index.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comments] = [

      stub_model(Comment,

        :body => "value for body",

        :user => "value for user",

        :article_id => 1


      ),


      stub_model(Comment,

        :body => "value for body",

        :user => "value for user",

        :article_id => 1


      )


    ]
  end

  it "renders a list of comments" do
    render

    response.should have_tag("tr>td", "value for body".to_s, 2)

    response.should have_tag("tr>td", "value for user".to_s, 2)

    response.should have_tag("tr>td", 1.to_s, 2)

  end
end
