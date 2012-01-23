require 'spec_helper'
require "pathname"

$t = 0

describe "ActionView hacks" do
  include TestInlineRenderer

  it "should works with stylesheet_link_tag" do
    str = render_haml "= stylesheet_link_tag 'application'"
    
    str.should =~ %r{link.+href="/stylesheets/application.css.*"}
  end

  it "should work with data- attributes and nested hashes" do
    str = render_haml('= link_to "An", ?#, data: data_hash', data_hash: {a: 1, b: '2', c: 0.111}).gsub(?', ?")

    str.should =~ /data\-a="1"/
    str.should =~ /data\-b="2"/
    str.should =~ /data\-c="0.111"/
  end
  
  it "should make itemscope as boolean attribute" do
    str = render_haml('= tag ?p, itemscope: true')
    str.should =~ %r{<p\s+itemscope\s*/?>}
  end
end