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
    ActionController::Base.new.render_to_string(file: file, locals: options)
  end
  
  def render_haml(template, options = {})
    $t += 1
    file = File.expand_path(File.dirname(__FILE__) + "/../tmp/#{$t}.haml")
    File.delete(file) if File.exist?(file)
    File.open(file, 'w+') {|f| f.write template }
    render_file(file, options)
  end
end