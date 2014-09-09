require 'spec_helper'

describe ActiveModel do
  it "should check ActiveModel extention" do
    ActiveRecord::Base.should respond_to(:html_schema_type)
  end

  it "should return schema-type on #html_schema_type" do
    Post.html_schema_type.should == Post.new.html_schema_type
  end

  it "should return instance of kind Mida::Vocabulary" do
    Post.new.html_schema_type.should == Mida::SchemaOrg::BlogPosting
  end

  it "should return string on unknown itemtype" do
    User.html_schema_type.should == "http://example.com/User"
  end

  it "should return properties" do
    # make sure it load parents' properties
    Post.html_schema_type.properties.keys.size.should >= 60
  end
end