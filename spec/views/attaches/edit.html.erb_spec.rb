require 'spec_helper'


describe "/attaches/edit.html.erb" do
  include AttachesHelper

  before(:each) do
    assigns[:attach] = @attach = stub_model(Attach,
      :new_record? => false,

      :filename => "value for filename",

      :article_id => 1

    )
  end

  it "renders the edit attach form" do
    render

    response.should have_tag("form[action=#{attach_path(@attach)}][method=post]") do

      with_tag('input#attach_filename[name=?]', "attach[filename]")

      with_tag('input#attach_article_id[name=?]', "attach[article_id]")

    end
  end
end
