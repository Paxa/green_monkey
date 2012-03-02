require 'bundler/setup'

require 'rubygems'

require 'action_view'
require 'sinatra'
require 'green_monkey'
require 'ostruct'


get '/' do
  @post = OpenStruct.new(
    html_schema_type: Mida(:BlogPosting),
    id: 5, 
    title: 'Hello world', 
    body: 'Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort',
    created_at: Time.parse('10-feb-2012')
  )
  erb :index
end

__END__

@@ index
<DOCTYPE html>
<html>
  <head></head>
  <body>
    <article <%= mida_scope(@post) %>>
      <a href="/posts/<%= @post.id%>" itemprop="url">
        <h3 itemprop="name"><%= @post.title %></h3>
      </a>

      <div class="post_body" itemprop="articleBody"><%= @post.body %></div>
      <%= time_tag @post.created_at, itemprop: 'datePublished' %>
    </article>
  </body>
</html>