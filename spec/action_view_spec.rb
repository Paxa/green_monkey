require 'spec_helper'
require "pathname"

$t = 0

describe "ActionView hacks" do
  include TestInlineRenderer

  it "should works with stylesheet_link_tag" do
    str = render_haml "= stylesheet_link_tag 'application', skip_pipeline: true"
    
    str.should =~ %r{link.+href="/stylesheets/application.css.*"}
  end

  if Rails.version =~ /^3\.[12].*/
    it "should work with data- attributes and nested hashes" do
      str = render_haml('= link_to "An", ?#, data: data_hash', data_hash: {a: 1, b: '2', c: 0.111}).gsub(?', ?")

      str.should =~ /data\-a="1"/
      str.should =~ /data\-b="2"/
      str.should =~ /data\-c="0.111"/
    end
  end

  it "should make itemscope as boolean attribute" do
    str = render_haml('= tag ?p, itemscope: true')
    str.should =~ %r{<p\s+itemscope\s*/?>}
  end

  it "haml should render itemscope as boolean attribute" do
    str = render_haml('%p{itemscope: true}')
    str.should =~ %r{<p\s+itemscope\s*/?>}
  end

  it "should make breadcrumb link" do
    str = render_haml('= breadcrumb_link_to("Home", "/")').strip
    str.index('http://data-vocabulary.org/Breadcrumb').should_not == nil
    str.should == '<span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">' +
                    '<a itemprop="url" href="/"><span itemprop="title">Home</span></a>' +
                  '</span>'
  end
end