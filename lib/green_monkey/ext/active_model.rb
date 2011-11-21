# coding: utf-8

module GreenMonkey
  module ModelHelpers
    extend ActiveSupport::Concern
    
    
    module ClassMethods
      def html_schema_type(value = nil)
        return @html_schema_type unless value

        value = /#{value}/ if value.is_a?(Symbol)
        if value.is_a?(Regexp)
          value = Mida::Vocabulary.vocabularies.find do |vocabulary|
            vocabulary.itemtype.to_s =~ value && vocabulary.itemtype.to_s
          end
        end

        @html_schema_type = value
      end
    end
    
    module InstanceMethods
      def html_schema_type
        self.class.html_schema_type
      end
    end
  end
end