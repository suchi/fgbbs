require 'spec_helper'


describe "/articles/show.html.erb" do
  include ArticlesHelper
  before(:each) do
    assigns[:article] = @article = stub_model(Article,

      :title => "value for title",

      :body => "value for body",

      :user => "value for user"


    )

  end

  it "renders attributes in <p>" do
    render

    response.should have_text(/value\ for\ title/)

    response.should have_text(/value\ for\ body/)

    response.should have_text(/value\ for\ user/)

  end
end
