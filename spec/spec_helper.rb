ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['RAILS_ENV'] ||= 'development'

require 'bundler/setup'

require 'rails/all'
require 'rails/generators'
require 'rails/generators/test_case'

require "green_monkey"

module TestApp
  class Application < Rails::Application
    config.root = File.dirname(__FILE__)
    config.active_support.deprecation :log
    #config.logger = Logger.new(STDOUT)
    config.log_level = :error
  end
end

Rails.application = TestApp::Application

module Rails
  def self.root
    @root ||= File.expand_path("../../tmp/rails", __FILE__)
  end
end

Rails.application.config.root = Rails.root
Rails.application.config.eager_load = false

TestApp::Application.initialize!

ActiveRecord::Schema.define(:version => 20111023054000) do
  create_table "posts" do |t|
    t.string   "title"
    t.text     "body"
    t.string   "link"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "users" do |t|
    t.string   "name"
    t.string   "location"
    t.string   "github"
    t.string   "password"
  end
end

class Post < ActiveRecord::Base
  html_schema_type :BlogPosting
end

class User < ActiveRecord::Base
  html_schema_type "http://example.com/User"
end

module TestInlineRenderer
  def render_file(file, options = {})
    ActionController::Base.new.render_to_string(file: file, locals: options, handlers: [:haml])
  end
  
  def render_haml(template, options = {})
    $t += 1
    file = File.expand_path(File.dirname(__FILE__) + "/../tmp/#{$t}.haml")
    File.delete(file) if File.exist?(file)
    File.open(file, 'w+') {|f| f.write template }
    render_file(file.sub(/.haml$/, ''), options)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

# Simple microdata parser
def parse_mida_page(str)
  require 'nokogiri'
  doc = Nokogiri::HTML(str)
  items = []
  doc.css('[itemscope]').each do |scope|
    item = {type: scope.attr('itemtype'), id: scope.attr('itemid')}
    props = {}
    scope.css('[itemprop]').each do |el|
      prop_name = el.attr('itemprop')
      if prop_name == 'url'
        prop_value = el.attr('href')
      elsif prop_name == 'datePublished' || prop_name.start_with?('date')
        prop_value = DateTime.parse(el.attr('datetime'))
      else
        prop_value = el.inner_text
      end
      props[prop_name] ||= []
      props[prop_name] << prop_value
    end

    item[:properties] = props
    items << item
  end
  items
end