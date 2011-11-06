require 'spec_helper'


describe "/articles/edit.html.erb" do
  include ArticlesHelper

  before(:each) do
    assigns[:article] = @article = stub_model(Article,
      :new_record? => false,

      :title => "value for title",

      :body => "value for body",

      :user => "value for user"

    )
  end

  it "renders the edit article form" do
    render

    response.should have_tag("form[action=#{article_path(@article)}][method=post]") do

      with_tag('input#article_title[name=?]', "article[title]")

      with_tag('textarea#article_body[name=?]', "article[body]")

      with_tag('input#article_user[name=?]', "article[user]")

    end
  end
end
