# Green Monkey

## About

This Gem allows you to make html-layout with microdata properties easier. It works with ruby 1.9, rails 3, haml 3.

![Green Monkey](http://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Bijilo-Portrait-of-a-Callithrix-Monkey.jpg/320px-Bijilo-Portrait-of-a-Callithrix-Monkey.jpg)

## Install

Add to Gemfile

```ruby
gem "green_monkey"
```

## Examples

### helper `time_tag`

It almost as rails' time_tag but make `datetime` attribute in iso8601 format, according to Microdata specifications
Also it accepts Numeric values as duration

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

### ActiveRecord::Base#html\_schema\_type

```ruby
class User < ActiveRecord::Base
  html_schema_type :Person
end

User.html_schema_type #=> Mida::SchemaOrg::Person
User.find(1).html_schema_type => Mida::SchemaOrg::Person
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

--------

I use it in [Microdata tools](http://github.com/paxa/semantic_data/ "my own project")
