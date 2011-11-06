require 'spec_helper'


describe "/attaches/show.html.erb" do
  include AttachesHelper
  before(:each) do
    assigns[:attach] = @attach = stub_model(Attach,

      :filename => "value for filename",

      :article_id => 1


    )

  end

  it "renders attributes in <p>" do
    render

    response.should have_text(/value\ for\ filename/)

    response.should have_text(/1/)

  end
end
