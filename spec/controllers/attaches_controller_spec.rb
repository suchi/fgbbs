require 'spec_helper'

describe AttachesController do

  def mock_attach(stubs={})
    @mock_attach ||= mock_model(Attach, stubs)
  end

  describe "GET index" do
    it "assigns all attaches as @attaches" do
      Attach.stub(:find).with(:all).and_return([mock_attach])
      get :index
      assigns[:attaches].should == [mock_attach]
    end
  end

  describe "GET show" do
    it "assigns the requested attach as @attach" do
      Attach.stub(:find).with("37").and_return(mock_attach)
      get :show, :id => "37"
      assigns[:attach].should equal(mock_attach)
    end
  end

  describe "GET new" do
    it "assigns a new attach as @attach" do
      Attach.stub(:new).and_return(mock_attach)
      get :new
      assigns[:attach].should equal(mock_attach)
    end
  end

  describe "GET edit" do
    it "assigns the requested attach as @attach" do
      Attach.stub(:find).with("37").and_return(mock_attach)
      get :edit, :id => "37"
      assigns[:attach].should equal(mock_attach)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created attach as @attach" do
        Attach.stub(:new).with({'these' => 'params'}).and_return(mock_attach(:save => true))
        post :create, :attach => {:these => 'params'}
        assigns[:attach].should equal(mock_attach)
      end

      it "redirects to the created attach" do
        Attach.stub(:new).and_return(mock_attach(:save => true))
        post :create, :attach => {}
        response.should redirect_to(attach_url(mock_attach))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved attach as @attach" do
        Attach.stub(:new).with({'these' => 'params'}).and_return(mock_attach(:save => false))
        post :create, :attach => {:these => 'params'}
        assigns[:attach].should equal(mock_attach)
      end

      it "re-renders the 'new' template" do
        Attach.stub(:new).and_return(mock_attach(:save => false))
        post :create, :attach => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested attach" do
        Attach.should_receive(:find).with("37").and_return(mock_attach)
        mock_attach.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :attach => {:these => 'params'}
      end

      it "assigns the requested attach as @attach" do
        Attach.stub(:find).and_return(mock_attach(:update_attributes => true))
        put :update, :id => "1"
        assigns[:attach].should equal(mock_attach)
      end

      it "redirects to the attach" do
        Attach.stub(:find).and_return(mock_attach(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(attach_url(mock_attach))
      end
    end

    describe "with invalid params" do
      it "updates the requested attach" do
        Attach.should_receive(:find).with("37").and_return(mock_attach)
        mock_attach.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :attach => {:these => 'params'}
      end

      it "assigns the attach as @attach" do
        Attach.stub(:find).and_return(mock_attach(:update_attributes => false))
        put :update, :id => "1"
        assigns[:attach].should equal(mock_attach)
      end

      it "re-renders the 'edit' template" do
        Attach.stub(:find).and_return(mock_attach(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested attach" do
      Attach.should_receive(:find).with("37").and_return(mock_attach)
      mock_attach.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the attaches list" do
      Attach.stub(:find).and_return(mock_attach(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(attaches_url)
    end
  end

end
