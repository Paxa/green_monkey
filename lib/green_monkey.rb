module GreenMonkey
  if defined? Rails
    require 'green_monkey/railtie'
  else
    require "green_monkey/ext/mida"
    require "green_monkey/ext/haml" if defined? Haml

    if defined? ActiveModel
      require "green_monkey/ext/active_model"
      ActiveModel::Dirty.send :include, GreenMonkey::ModelHelpers
    end

    if defined? ActionView
      require "green_monkey/ext/action_view"
      require 'green_monkey/ext/view_helper'
      ActionView::Base.send :include, GreenMonkey::ViewHelper
    end
  end

  if defined?(Sinatra)
    require 'green_monkey/ext/view_helper'
    Sinatra.helpers do
      include ActionView::Helpers::TagHelper if defined?(ActionView)
      include GreenMonkey::ViewHelper
    end
  end
end