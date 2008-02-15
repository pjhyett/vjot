module DataMapper
  module Support
    module Enumerable
      
      # Group a collection of elements into groups within a
      # Hash. The value returned by the block passed to group_by
      # is the key, and the value is an Array of items matching
      # that key.
      #
      # === Example
      #   names = %w{ sam scott amy robert betsy }
      #   names.group_by { |name| name.size }
      #   => { 3 => [ "sam", "amy" ], 5 => [ "scott", "betsy" ], 6 => [ "robert" ]}  
      def group_by
        inject(Hash.new { |h,k| h[k] = [] }) do |memo,item|
          memo[yield(item)] << item; memo
        end
      end
  
    end # module Enumerable
  end # module Support
end # module DataMapper

# Extend Array with DataMapper::Support::Enumerable
class Array #:nodoc:
  include DataMapper::Support::Enumerable
end