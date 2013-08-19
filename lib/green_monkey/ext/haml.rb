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
  
            
    def parse_object_ref(ref)
      return if ref.nil?
      opts = {}                               
      prefix = ''
      ref.each do |part|
        if part.is_a? Symbol
          prefix = "#{part.to_s}_"
        elsif part.is_a?(String)
          # itemprop
          part =~ /^#\w+$/ ? opts[:itemprop]= part[1..-1] : next
        elsif part.is_a? Mida::Vocabulary
          opts[:itemscope]= true
          opts[:itemtype]= part.itemtype.source
        else
          opts[:class]= part.respond_to?(:haml_object_ref) ? part.haml_object_ref : underscore(part.class)
          tmp_id =
            if part.respond_to?(:to_key)
              key = part.to_key
              key.join('_') unless key.nil?
            else
              part.id
            end
          opts[:id]= "#{opts[:class]}_#{tmp_id || 'new'}"          

          # hack for microdata attributes
          if part.respond_to?(:html_schema_type)
            opts[:itemscope] = true
            opts[:itemid] = part.id

            if part.html_schema_type.kind_of?(Mida::Vocabulary)
              opts[:itemtype] = part.html_schema_type.itemtype.source
            else
              raise "No vocabulary found (#{part.html_schema_type})" unless Mida::Vocabulary.find(part.html_schema_type)
              opts[:itemtype] = part.html_schema_type
            end
          end
         
        end          
         
      end 
      opts[:class] = prefix + opts[:class] if opts.key? :class
      opts[:id] = prefix + opts[:id] if opts.key? :id
      opts.stringify_keys
    end
   


end