require "mida"

class Mida::Vocabulary::Custom < Mida::Vocabulary
  attr_reader :itemtype
  def initialize(itemtype)
    @itemtype = %r{#{itemtype}}
  end
end

def Mida(itemtype, addition = nil)
  if itemtype.is_a?(Symbol)
    itemtype = "http://schema.org/#{itemtype}"
  end

  found_voc = Mida::Vocabulary.find(itemtype)
  
  if found_voc == Mida::GenericVocabulary
    found_voc = Mida::Vocabulary::Custom.new(itemtype)
  end
  
  if addition
    Mida::Vocabulary::Custom.new(found_voc.itemtype.source + "/#{addition}")
  else
    found_voc
  end
end

class Mida::Vocabulary
  
  # this dutty hack fix some strange bug then 
  # Mida::Vocabulary.find "http://schema.org/BlogPosting"
  # => Mida::SchemaOrg::Blog
  def self.find(itemtype)
    @vocabularies.sort_by {|v| v.itemtype ? v.itemtype.source.size : 0 }.reverse.each do |vocabulary|
      if ((itemtype || "") =~ vocabulary.itemtype) then return vocabulary end
    end
    nil
  end
end

require "uri"

module URI
  def to_json
    to_s.to_json
  end
end