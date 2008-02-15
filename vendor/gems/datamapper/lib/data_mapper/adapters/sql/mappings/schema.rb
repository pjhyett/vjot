require File.dirname(__FILE__) + '/table'
    
module DataMapper
  module Adapters
    module Sql
      module Mappings
    
        class Schema
    
          def initialize(adapter)
            @adapter = adapter
            @tables = Hash.new { |h,k| h[k] = Table.new(@adapter, k) }
          end

          def [](klass)
            @tables[klass]
          end
      
          def each
            @tables.values.each do |table|
              yield table
            end
          end
    
        end
    
      end
    end
  end
end