require File.dirname(__FILE__) + '/blank_slate'

class Proc
  
  # Yeah, all this is kinda the suck.
  def to_hash
    Conditions.new(&self).__to_hash__
  end
  
  class Conditions < BlankSlate
    
    def initialize(&block)
      @block = block
      @conditions = []
    end
    
    def method_missing(sym, *args)
      attribute = Attribute.new(sym)
      @conditions << attribute
      attribute
    end
    
    def __to_hash__
      instance_eval(&@block)      
      @conditions.inject({}) do |h,attribute|
        h[attribute.__operator__] = *attribute.__args__; h
      end
    end
    
    class Attribute < BlankSlate
      
      def initialize(message)
        @message = message
        @args = nil
        @operator = nil
      end
    
      def method_missing(sym, *args)
        op = case sym
          when :==, :===, :in then :eql
          when :=~ then :like
          when :"<=>" then :not
          when :< then :lt
          when :<= then :lte
          when :> then :gt
          when :>= then :gte
          else sym
        end
        
        @operator = Symbol::Operator.new(@message, op)
        @args = args
      end
      
      def __operator__
        @operator
      end
      
      def __args__
        @args
      end
    
      def __message__
        @message
      end
      
    end
        
  end
end