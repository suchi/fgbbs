require 'spec_helper'


describe "/attaches/new.html.erb" do
  include AttachesHelper

  before(:each) do
    assigns[:attach] = stub_model(Attach,
      :new_record? => true,

      :filename => "value for filename",

      :article_id => 1

    )
  end

  it "renders new attach form" do
    render

    response.should have_tag("form[action=?][method=post]", attaches_path) do

      with_tag("input#attach_filename[name=?]", "attach[filename]")

      with_tag("input#attach_article_id[name=?]", "attach[article_id]")

    end
  end
end
