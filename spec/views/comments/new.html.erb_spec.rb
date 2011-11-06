require 'spec_helper'


describe "/comments/new.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comment] = stub_model(Comment,
      :new_record? => true,

      :body => "value for body",

      :user => "value for user",

      :article_id => 1

    )
  end

  it "renders new comment form" do
    render

    response.should have_tag("form[action=?][method=post]", comments_path) do

      with_tag("textarea#comment_body[name=?]", "comment[body]")

      with_tag("input#comment_user[name=?]", "comment[user]")

      with_tag("input#comment_article_id[name=?]", "comment[article_id]")

    end
  end
end
