# Add support for "itemscope" html attributes

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
    str = tag_options_before_green_monkey(options, escape)

    if options['itemscope'] || options[:itemscope]
      str = (str + '').sub(/itemscope=('|")itemscope('|")/, 'itemscope').html_safe
    end

    str
  end
end