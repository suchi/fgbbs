require 'spec_helper'


describe "/articles/new.html.erb" do
  include ArticlesHelper

  before(:each) do
    assigns[:article] = stub_model(Article,
      :new_record? => true,

      :title => "value for title",

      :body => "value for body",

      :user => "value for user"

    )
  end

  it "renders new article form" do
    render

    response.should have_tag("form[action=?][method=post]", articles_path) do

      with_tag("input#article_title[name=?]", "article[title]")

      with_tag("textarea#article_body[name=?]", "article[body]")

      with_tag("input#article_user[name=?]", "article[user]")

    end
  end
end
