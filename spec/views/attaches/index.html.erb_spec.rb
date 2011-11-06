require 'spec_helper'


describe "/attaches/index.html.erb" do
  include AttachesHelper

  before(:each) do
    assigns[:attaches] = [

      stub_model(Attach,

        :filename => "value for filename",

        :article_id => 1


      ),


      stub_model(Attach,

        :filename => "value for filename",

        :article_id => 1


      )


    ]
  end

  it "renders a list of attaches" do
    render

    response.should have_tag("tr>td", "value for filename".to_s, 2)

    response.should have_tag("tr>td", 1.to_s, 2)

  end
end
