require 'bundler/setup'

require 'rubygems'
require 'haml'
require 'sinatra'
require 'action_view' # for time_tag support
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
  haml :index
end

__END__

@@ index
!!! 5
%html
  %head
  %body
    %article[@post]
      %a[:url]{:href => "/posts/#{@post.id}"}
        %h3[:name]>= @post.title
      .post_body[:articleBody]= @post.body
      = time_tag @post.created_at, itemprop: 'datePublished'