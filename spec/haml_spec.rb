require 'spec_helper'
require "pathname"
require "mida"

$t = 0

describe "Haml generation" do
  include TestInlineRenderer
  
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
    render_haml("%b['#title'] Dada").should =~ /itemprop=.?title/
  end
  

  it 'should render itemscope for Mida::Vocabulary' do
    str = render_haml("%b[Mida(:Event)]")
    str.should =~ /itemtype=('|")#{Regexp.escape 'http://schema.org/Event'}('|")/
    str.should =~ /itemscope/
  end


  it "should generate valid microdata layout" do
    post = Post.create(title: "Post 1", body: "Some text")
    tpl = Pathname.new(__FILE__).dirname.join("post")
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
  
  describe 'time_tag' do
    it "should produce itemprop if specified" do
      str = render_haml("= time_tag(Time.now, itemprop: 'time')")
      str.should =~ /itemprop="time"/
    end
    
    it "should run with time" do
      time = Time.now
      str = render_haml("= time_tag(time)", time: time)

      str.should =~ /<time.+datetime=.?#{Regexp.escape time.iso8601}/
    end

    it "should run with duration" do
      str = render_haml("= time_tag(time)", time: 3.hours + 30.minutes)
      str.should =~ /datetime=.PT3H30M/
    end

    it "should run with time interval of 2 dates" do
      time = [Time.parse("14 March 1879"), Time.parse("18 April 1955")]

      str = render_haml("= time_tag_interval(*time, :format => '%d %h %Y')", time: time)
      str.should =~ /<time.+datetime=.?#{Regexp.escape time[0].iso8601}\/#{Regexp.escape time[1].iso8601}/
    end

    it "should run with date and duration" do
      time = [Time.parse("6 May 1989"), 150.hours]
      str = render_haml("= time_tag_interval(*time, :format => :short)", time: time)
      str.should =~ /<time.+datetime=.?#{Regexp.escape time[0].iso8601}\/P6DT6H/
    end
    
    it "should add class from model" do
      user = User.create
      tpl = "%article.person[user]"
      str = render_haml(tpl, user: user)
      html_class = str.match(/class=['"]([\w\s]+)['"]/)[1]
      html_class.should =~ /person/
      html_class.should =~ /user/
    end
    
    it "should make itemscope as boolean attribute" do
      str = render_haml("%div{:itemscope => true}")
      str.should =~ %r{<div\s+itemscope\s*/?>}
    end
  end
end
