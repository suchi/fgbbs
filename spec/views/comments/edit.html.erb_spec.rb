require 'spec_helper'


describe "/comments/edit.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comment] = @comment = stub_model(Comment,
      :new_record? => false,

      :body => "value for body",

      :user => "value for user",

      :article_id => 1

    )
  end

  it "renders the edit comment form" do
    render

    response.should have_tag("form[action=#{comment_path(@comment)}][method=post]") do

      with_tag('textarea#comment_body[name=?]', "comment[body]")

      with_tag('input#comment_user[name=?]', "comment[user]")

      with_tag('input#comment_article_id[name=?]', "comment[article_id]")

    end
  end
end
