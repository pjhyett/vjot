module DataMapper
  module Support
    module Symbol
      
      class Operator
      
        attr_reader :value, :type, :options
      
        def initialize(value, type, options = nil)
          @value, @type, @options = value, type, options
        end
    
        def to_sym
          @value
        end
      end
    
      def gt
        Operator.new(self, :gt)
      end
  
      def gte
        Operator.new(self, :gte)
      end
  
      def lt
        Operator.new(self, :lt)
      end
  
      def lte
        Operator.new(self, :lte)
      end
  
      def not
        Operator.new(self, :not)
      end
  
      def eql
        Operator.new(self, :eql)
      end
  
      def like
        Operator.new(self, :like)
      end
  
      def in
        Operator.new(self, :in)
      end
  
      def select(klass = nil)    
        Operator.new(self, :select, { :class => klass })
      end
  
      def to_s
        @string_form || (@string_form = id2name.freeze)
      end
  
      def to_proc
       lambda { |value| value.send(self) }
      end
      
      def as_instance_variable_name
        @instance_variable_name_form || (@instance_variable_name_form = "@#{id2name}".freeze)
      end
  
      # Calculations:
  
      def count
        Operator.new(self, :count)
      end
  
      def max
        Operator.new(self, :max)
      end
  
      def avg
        Operator.new(self, :avg)
      end
      alias average avg
  
      def min
        Operator.new(self, :min)
      end
      
    end # module Symbol
  end # module Support
end # module DataMapper

class Symbol #:nodoc:
  include DataMapper::Support::Symbol
end