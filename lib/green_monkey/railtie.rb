# coding: utf-8

module GreenMonkey
  class Railtie < Rails::Railtie
    initializer 'green_monkey.init', :before => :load_config_initializers do
      require "green_monkey/ext/active_model"
      ActiveModel::Dirty.send :include, GreenMonkey::ModelHelpers
      ActiveRecord::Base.send :include, GreenMonkey::ModelHelpers

      require 'green_monkey/ext/view_helper'
      ActionView::Base.send :include, GreenMonkey::ViewHelper

      require "green_monkey/ext/action_view"
      require "green_monkey/ext/haml"
      require "green_monkey/ext/mida"
    end
  end
end