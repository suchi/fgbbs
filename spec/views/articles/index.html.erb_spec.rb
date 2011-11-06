require 'spec_helper'


describe "/articles/index.html.erb" do
  include ArticlesHelper

  before(:each) do
    assigns[:articles] = [

      stub_model(Article,

        :title => "value for title",

        :body => "value for body",

        :user => "value for user"


      ),


      stub_model(Article,

        :title => "value for title",

        :body => "value for body",

        :user => "value for user"


      )


    ]
  end

  it "renders a list of articles" do
    render

    response.should have_tag("tr>td", "value for title".to_s, 2)

    response.should have_tag("tr>td", "value for body".to_s, 2)

    response.should have_tag("tr>td", "value for user".to_s, 2)

  end
end
