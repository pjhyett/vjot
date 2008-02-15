module DataMapper
  module Adapters
    module Sql
      # Coersion is a mixin that allows for coercing database values to Ruby Types.
      #
      # DESIGN: Probably should handle the opposite scenario here too. I believe that's
      # currently in DataMapper::Database, which is obviously not a very good spot for
      # it.
      module Coersion
        
        TRUE_ALIASES = ['true'.freeze, 'TRUE'.freeze]
        FALSE_ALIASES = [nil]
        
        def self.included(base)
          base.const_set('TRUE_ALIASES', TRUE_ALIASES.dup)
          base.const_set('FALSE_ALIASES', FALSE_ALIASES.dup)
        end
        
        def type_cast_boolean(raw_value)
          case raw_value
            when TrueClass, FalseClass then raw_value
            when *self::class::TRUE_ALIASES then true
            when *self::class::FALSE_ALIASES then false
            else "Can't type-cast #{value.inspect} to a boolean"
          end
        end
        
        def type_cast_string(raw_value)
          return nil if raw_value.blank?
          raw_value
        end
        
        def type_cast_text(raw_value)
          return nil if raw_value.blank?
          raw_value
        end
        
        def type_cast_class(raw_value)
          return nil if raw_value.blank?
          Kernel::const_get(raw_value)
        end
        
        def type_cast_integer(raw_value)
          return nil if raw_value.blank?
          raw_value.to_i # Integer(raw_value) would be "safer", but not as fast.
        rescue ArgumentError
          nil
        end
        
        def type_cast_datetime(raw_value)
          return nil if raw_value.blank?
          
          case raw_value
            when DateTime then raw_value
            when Date then DateTime.new(raw_value)
            when String then DateTime::parse(raw_value)
            else "Can't type-cast #{raw_value.inspect} to a datetime"
          end
        end
        
        def type_cast_value(type, raw_value)
          return nil if raw_value.blank?
          
          if respond_to?("type_cast_#{type}")
            send("type_cast_#{type}", raw_value)
          else
            raise "Don't know how to type-cast #{{ type => raw_value }.inspect }"
          end
        end

      end # module Coersion
    end
  end  
end