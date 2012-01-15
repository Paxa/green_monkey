require 'spec_helper'
require "pathname"

$t = 0

describe "ActionView hacks" do
  include TestInlineRenderer
  
  it "should works with stylesheet_link_tag" do
    tpl = "= stylesheet_link_tag 'application'"
    str = render_haml(tpl)
    
    str.should =~ %r{link.+href="/stylesheets/application.css.*"}
  end
end