require 'spec_helper'

describe AttachesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/attaches" }.should route_to(:controller => "attaches", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/attaches/new" }.should route_to(:controller => "attaches", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/attaches/1" }.should route_to(:controller => "attaches", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/attaches/1/edit" }.should route_to(:controller => "attaches", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/attaches" }.should route_to(:controller => "attaches", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/attaches/1" }.should route_to(:controller => "attaches", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/attaches/1" }.should route_to(:controller => "attaches", :action => "destroy", :id => "1") 
    end
  end
end
