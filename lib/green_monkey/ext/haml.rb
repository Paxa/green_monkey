require "haml"

# this hack looks at active-record object's :html_schema_type field and adds itemscope, itemid and itemtype to element
# example:
#
# %article[post] 
# => <article class="post" itemscope itemtype="http://schema.org/BlogPosting" itemid="1">
#
# %section[Mida(:Blog)]
# => <section itemscope itemtype="http://schema.org/Blog">
#
# %section[Mida(:Blog), :sexjokes]
# => <section itemscope itemtype="http://schema.org/Blog/SexJokes">
# according to "Extension Mechanism" at http://schema.org/docs/extension.html
#
# %span[:title] Hello
# => <span itemprop="title">Hello</span>

class Haml::Buffer
  
  # this methods calls then you pass
  # %tag[object1, object2]
  # ref argument is array
  def parse_object_ref(ref)
    options = {}
    ref.each do |obj|
      next if obj == "local-variable"
      self.class.merge_attrs(options, process_object_ref(obj))
    end
    
    options
  end
  
  def process_object_ref(obj)
    return {} if !obj
    
    if obj.is_a?(Symbol)
      # symbol => "itemprop" attribute
      return {'itemprop' => obj.to_s}
    elsif obj.kind_of?(Mida::Vocabulary)
      # Mida::Vocabulary => itemprop and itemtype
      return {itemscope: true, itemtype: obj.itemtype.source}
    elsif obj.is_a?(String)
      return {class: obj}
    else
      options = {}
      options[:class] = obj.respond_to?(:haml_object_ref) ? obj.haml_object_ref : underscore(obj.class)
      options[:id] = "#{options[:class]}_#{obj.id || 'new'}" if obj.respond_to?(:id)
      
      # my hack for microdata attributes
      if obj.respond_to?(:html_schema_type)
        options[:itemscope] = true
        options[:itemid] = obj.id
        
        if obj.html_schema_type.kind_of?(Mida::Vocabulary)
          options[:itemtype] = obj.html_schema_type.itemtype.source
        else
          raise "No vocabulary found (#{obj.html_schema_type})" unless Mida::Vocabulary.find(obj.html_schema_type)
          options[:itemtype] = obj.html_schema_type
        end
      end
      
      return options
    end
  end

end