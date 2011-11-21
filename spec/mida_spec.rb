require 'spec_helper'

describe "Mida helper" do
  it "should find vocabulary class" do
    Mida(:BlogPosting).should == Mida::SchemaOrg::BlogPosting
    Mida("http://schema.org/BlogPosting").should == Mida::SchemaOrg::BlogPosting
    
    custom = Mida("http://t.co/BlogPosting")
    custom.itemtype.source == "http://t.co/BlogPosting"
    custom.class.should == Mida::Vocabulary::Custom
  end
  
  it "should make Mida::Vocabulary::Custom for extended vocabularies" do
    extended = Mida(:Blog, :SexJokes)
    extended.class.should == Mida::Vocabulary::Custom
    extended.itemtype.source == "http://schema.org/Blog/SexJokes"
  end
end