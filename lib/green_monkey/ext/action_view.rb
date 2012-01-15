module ActionView::Helpers::TagHelper
  BOOLEAN_ATTRIBUTES.merge(['itemscope', :itemscope])

  private
  def tag_options(options, escape = true)
    #p [options, escape, BOOLEAN_ATTRIBUTES]
    unless options.blank?
      attrs = []
      options.each_pair do |key, value|
        if BOOLEAN_ATTRIBUTES.include?(key)
          attrs << key.to_s if value
        elsif !value.nil?
          final_value = value.is_a?(Array) ? value.join(" ") : value
          final_value = ERB::Util.html_escape(final_value) if escape
          attrs << %(#{key}="#{final_value}")
        end
      end

      " #{attrs.sort * ' '}".html_safe unless attrs.empty?
    end
  end
end