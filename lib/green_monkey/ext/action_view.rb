module ActionView::Helpers::TagHelper
  # Rails by default does not behave with itemscope as boolean attribute
  # and renders it as itemscope="true"
  
  # this changes make it render as itemscope="itemscope"
  BOOLEAN_ATTRIBUTES.merge(['itemscope', :itemscope])

  private
  
  # this hack replaces itemscope="itemscope" => itemscope
  # to make it follow standarts (http://www.w3.org/TR/microdata/#typed-items)
  alias_method :tag_options_before_green_monkey, :tag_options
  def tag_options(options, escape = true)
    tag_options_before_green_monkey(options, escape).tap do |str|
      if options['itemscope'] || options[:itemscope]
        str.sub!(/itemscope=('|")itemscope('|")/, 'itemscope')
      end
    end
  end
end