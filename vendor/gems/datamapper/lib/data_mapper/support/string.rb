module DataMapper
  module Support
    module String
      
      # I set the constant on the String itself to avoid inheritance chain lookups.
      def self.included(base)
        base.const_set('EMPTY', ''.freeze)
      end
      
      def ensure_starts_with(part)
        [0,1] == part ? self : (part + self)
      end
  
      def ensure_ends_with(part)
        [-1,1] == part ? self : (self + part)
      end
  
      def ensure_wrapped_with(a, b = nil)
        ensure_starts_with(a).ensure_ends_with(b || a)
      end
      
    end # module String
  end # module Support
end # module DataMapper

class String #:nodoc:
  include DataMapper::Support::String
end