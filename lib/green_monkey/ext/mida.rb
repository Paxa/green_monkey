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

require "uri"

module URI
  def to_json
    to_s.to_json
  end
end