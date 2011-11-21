require 'spec_helper'
require "pathname"

$t = 0

describe "Haml generation" do
  def render_file(file, options = {})
    ActionController::Base.new.render_to_string(file: file, locals: options)
  end
  
  def render_haml(template, options = {})
    $t += 1
    file = File.expand_path(File.dirname(__FILE__) + "/../tmp/#{$t}.haml")
    File.delete(file) if File.exist?(file)
    File.open(file, 'w+') {|f| f.write template }
    render_file(file, options)
  end
  
  it "should render itemscope as a boolean attribute" do
    render_haml("%b{:itemscope => true}").should =~ /<b\s+itemscope\s*>/
  end
  
  it "should get AR object" do
    user = User.create
    tpl = "%article[user]"
    str = render_haml(tpl, user: user)
    
    str.should =~ /itemtype=('|")#{Regexp.escape 'http://example.com/User'}('|")/
    str.should =~ /itemid=.?#{user.id}/
    str.should =~ /itemscope/
  end
  
  it "should render itemprop attribute" do
    render_haml("%b[:title] Dada").should =~ /itemprop=.?title/
  end
  
  it "should run time_tag" do
    time = Time.now
    str = render_haml("= time_tag(time)", time: time)
    
    str.should =~ /<time.+datetime=.?#{Regexp.escape time.iso8601(10)}/
  end
  
  it "should generate valid microdata layout" do
    post = Post.create(title: "Post 1", body: "Some text")
    tpl = Pathname.new(__FILE__).dirname.join("post.haml")
    str = render_file(tpl, post: post)

    doc = Mida::Document.new(str, "http://example.com/")
    
    props = doc.items[0].properties
    props['url'][0].to_s.should == "http://example.com/posts/#{post.id}"
    props['name'][0].should == post.title
    props['articleBody'][0].should == post.body
    props['datePublished'][0].to_i.should == post.created_at.to_i
    
    doc.items[0].id.should == post.id.to_s
    doc.items[0].type.should == post.html_schema_type.itemtype.source
  end
end