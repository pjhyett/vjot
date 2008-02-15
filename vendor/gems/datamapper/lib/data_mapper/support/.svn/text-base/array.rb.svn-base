module DataMapper
  module Support
    module Array
      
      # Calling Array.sift selects all desired items that match the supplied regex or block and
      # discards the rest.
      # ["proc", "zoo_association", "singleton_method_added"].sift /_association/ # => ["zoo_association"]
      def sift(string_or_regex = nil, &block)
        unless block
          grep(string_or_regex)
        else
          find_all { |x| yield x }
        end
      end
      
      # Calling Array.cull removes all items that match the supplied regex or block and returns
      # what is left.
      # ["proc", "zoo_association"].cull /_association/ # => ["proc"]
      def cull(string_or_regex = nil, &block)
        unless block
          self - grep(string_or_regex)
        else
          find_all { |x| !yield x }
        end
      end
      
    end # module Array
  end # module Support
end # module DataMapper

class Array #:nodoc:
  include DataMapper::Support::Array
end