# coding: utf-8

module GreenMonkey
  class Railtie < Rails::Railtie
    initializer "include view helper" do
      ActionView::Base.send :include, GreenMonkey::ViewHelper
    end
    
    initializer "load extentions and patches" do
      require "green_monkey/ext/active_model"
      ActiveModel::Dirty.send :include, GreenMonkey::ModelHelpers
      
      require "green_monkey/ext/action_view"
      require "green_monkey/ext/haml"
      require "green_monkey/ext/mida"
    end
  end
end