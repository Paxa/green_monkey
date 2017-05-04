# Green Monkey

## About

This Gem allows you to make html-layout with microdata properties easier. It works with ruby 2.2+, rails 4, rails 5, haml 5+.

![Green Monkey](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Bijilo-Portrait-of-a-Callithrix-Monkey.jpg/320px-Bijilo-Portrait-of-a-Callithrix-Monkey.jpg)

## Install

Add to Gemfile

```ruby
gem "green_monkey", '0.2.2'
```

## API

Extends `ActiveModel`:

```ruby
class Post < ActiveRecord::Base
  html_schema_type :BlogPosting
end

Post.html_schema_type # => Mida::SchemaOrg::BlogPosting
Post.new.html_schema_type # => Mida::SchemaOrg::BlogPosting

class User < ActiveRecord::Base
  html_schema_type "http://example.com/User"
end

User.html_schema_type # => "http://example.com/User"
```

Extends rails' view helpers:

```ruby
# add correct support for itemscope attribute
content_tag(:div, :itemscope) # => "<div itemscope>" (instead of <div "itemscope">

# time_tag with datetime attribute
time_tag(Time.now) # => <time datetime="2014-09-09T09:38:00+00:00">September 09, 2014 09:38</time>

# time_tag with microdata-compatible time interval
time_tag_interval(time, 1.hour + 20.minutes) # => <time datetime="2014-09-09T09:38:00+00:00/PT1H20M">September 09, 2014 09:38 in 1 hour 20 minutes</time>

# time interval iso8601 helper
time_to_iso8601(1.hour + 20.minutes) # => "PT1H20M"

#  shortcut to build "itemscope" and "itemtype" attributes
mida_scope(:Airline) # => ' itemscope itemtype="http://schema.org/Airline"'

# build a link with itemtype="http://data-vocabulary.org/Breadcrumb"
breadcrumb_link_to("Home", "/") # => <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/" itemprop="url"><span itemprop="title">Home</span></a></span>
```

## Examples

### helper `time_tag`

It almost the same with rails' time_tag but make `datetime` attribute in iso8601 format, according to Microdata specifications.
Also it accepts Numeric values as duration for time intervals

Haml & HTML:

```haml
= time_tag post.created_at
= time_tag post.created_at, itemprop: "datePublished"
= time_tag 3.hours + 30.minutes
```

```html
<time datetime="2011-11-23T00:00:00.0Z">23 Nov 2011</time>
<time datetime="2011-11-23T00:00:00.0Z" itemprop="datePublished">23 Nov 2011</time>
<time datetime="PT3H30M" title="3 hours 30 minutes">about 4 hours</time>
```

### helper `time_tag_interval`

The same with `time_tag` but made for time intervals

```haml
= time_tag_interval Time.parse("14 March 1879"), Time.parse("18 April 1955"), :format => '%d %h %Y'
= time_tag_interval Time.parse("14 March 1989"), 150.hours, :format => :short
```

```html
<time datetime="1879-03-14T00:00:00+07:30/1955-04-18T00:00:00+07:30">14 Mar 1879 - 18 Apr 1879</time>
<time datetime="1989-05-06T00:00:00+08:00/P6DT6H">06 May 00:00 in 6d 6h</time>
```

### ActiveRecord::Base#html\_schema\_type

```ruby
class User < ActiveRecord::Base
  html_schema_type :Person
end

User.html_schema_type #=> Mida::SchemaOrg::Person
User.find(1).html_schema_type #=> Mida::SchemaOrg::Person
```

### Haml magic

Attribute `itemprop`

```haml
%span[:name]= item.name
<span itemprop='name'>Item name</span>
```

`itemscope` and `iteptype` attributes

```haml
%article[Mida(:Event)] # =>
<article itemscope itemtype='http://schema.org/Event'></article>
    
%article[Mida(:Event, :DrinkUp)] # =>
<article itemscope itemtype='http://schema.org/Event/DrinkUp'></article>
    
%article[@user] # =>
<article class='user' id='1' itemid='1' itemscope iteptype='http://schema.org/Person'></article>
```

### Real examples
Haml:

```haml
%article[post]
  = link_to "/posts/#{post.id}", :itemprop => "url" do
    %h3[:name]>= post.title
  .post_body[:articleBody]= post.body.html_safe
  = time_tag(post.created_at, :itemprop => "datePublished")
```

Output:

```html
<article class='post' id='post_1' itemid='1' itemscope itemtype='http://schema.org/BlogPosting'>
  <a href="/posts/1" itemprop="url">
    <h3 itemprop='name'>Hello world!</h3>
  </a>
  <div class='post_body' itemprop='articleBody'>Some text</div>
  <time datetime="2011-11-22T09:16:57.0Z" itemprop="datePublished">November 22, 2011 09:16</time>
</article>
```

Haml:

```haml
%article[project]
  %header
    = link_to project.url, itemprop: 'url', target: "_blank" do
      %h3[:name]<>= project.title
    = " "
    - if project.source_code.present?
      = link_to "(source code)", project.source_code, class: "source_link", target: "_blank"
  %section[:description]
    = simple_format project.description
    
  %ul
    - for item_type in project.item_types.split(" ")
      %li[Mida(:WebPageElement, :ItemType), :mentions]
        %span[:name]= item_type
```

Output:

```html
<article class='project' id='project_2' itemid='2' itemscope itemtype='http://schema.org/WebPage'>
  <header>
    <a href="http://lawrencewoodman.github.com/mida/" itemprop="url" target="_blank">
      <h3 itemprop='name'>Mida - A Microdata extractor/parser library for Ruby</h3>
    </a>
    <a href="http://github.com/LawrenceWoodman/mida" class="source_link" target="_blank">(source code)</a>
  </header>
  
  <section itemprop='description'>
    <p>A Ruby Microdata parser/extractor</p>
  </section>
  
  <ul>
    <li itemprop='mentions' itemscope itemtype='http://schema.org/WebPageElement/ItemType'>
      <span itemprop='name'>http://schema.org/Blog</span>
    </li>
  </ul>
</article>
```
