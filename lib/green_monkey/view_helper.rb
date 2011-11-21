# coding: utf-8

module GreenMonkey
  module ViewHelper
    
    # it shortcut for this
    #%time{:datetime => post.published_at.iso8601(10) }= post.published_at.strftime("%d %h %Y")
    
    # = time_tag post.created_at
    # = time_tag post.created_at, format: "%d %h %Y %R%p"
    # = time_tag post.created_at, itemprop: "datePublished"
    def time_tag(time, options = {})
      format = options.delete(:format) || "%d %h %Y"
      default_options = {datetime: time.iso8601(10)}
      content_tag(:time, time.strftime(format), default_options.merge(options))
    end
  end
end