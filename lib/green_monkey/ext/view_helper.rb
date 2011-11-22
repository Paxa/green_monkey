# coding: utf-8

require "chronic_duration"
module GreenMonkey
  module ViewHelper
    
    # it shortcut for this
    #%time{:datetime => post.published_at.iso8601(10) }= post.published_at.strftime("%d %h %Y")
    
    # = time_tag post.created_at
    # = time_tag post.created_at, format: "%d %h %Y %R%p"
    # = time_tag post.created_at, itemprop: "datePublished"
    def time_tag(date_or_time, *args)
      options  = args.extract_options!
      format   = options.delete(:format) || :long
      
      if date_or_time.acts_like?(:time)
        title = nil
        content  = args.first || I18n.l(date_or_time, format: format)
        datetime = date_or_time.iso8601(10)
      elsif date_or_time.kind_of?(Numeric)
        title = ChronicDuration.output(date_or_time, :format => format)
        content = distance_of_time_in_words(date_or_time)
        datetime = ChronicDuration.output(date_or_time, :format => :iso8601)
      end
      
      content_tag(:time, content, options.reverse_merge(datetime: datetime, title: title))
    end
  end
end