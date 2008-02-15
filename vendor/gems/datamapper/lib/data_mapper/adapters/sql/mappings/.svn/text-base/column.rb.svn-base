module DataMapper
  module Adapters
    module Sql
      module Mappings
    
        # TODO: There are of course many more options to add here.
        # Ordinal, Length/Size, Nullability are just a few.
        class Column
    
          attr_accessor :name, :type, :options
    
          def initialize(adapter, name, type, options = {})
            @adapter = adapter
            @name, @type, @options = name.to_sym, type, options
            
            (class << self; self end).class_eval <<-EOS
              def type_cast_value(value)
                @adapter.type_cast_#{type}(value)
              end
            EOS
          end
    
          def lazy=(value)
            @options[:lazy] = value
          end
    
          # Determines if the field should be lazy loaded.
          # You can set this explicitly, or accept the default,
          # which is false for all but text fields.
          def lazy?
            nil
            #@options[:lazy] || (type == :text)
          end
      
          def nullable?
            @options[:nullable] || true
          end
      
          def key?
            @options[:key] || false
          end
    
          def to_sym
            @name
          end
      
          def instance_variable_name
            @instance_variable_name || (@instance_variable_name = "@#{@name.to_s.gsub(/\?$/, '')}".freeze)
          end
      
          def to_s
            @name.to_s
          end
      
          def column_name
            @column_name || (@column_name = (@options.has_key?(:column) ? @options[:column].to_s : name.to_s.gsub(/\?$/, '')).freeze)
          end
      
          def to_sql
            @to_sql || (@to_sql = @adapter.quote_column_name(column_name).freeze)
          end
      
          def size
            @size || begin
              return @size = @options[:size] if @options.has_key?(:size)
              return @size = @options[:length] if @options.has_key?(:length)
          
              @size = case type
                when :integer then 4
                when :string, :class then 50
                else nil
              end
            end
          end
      
          def inspect
            "#<%s:0x%x @name=%s, @type=%s, @options=%s>" % [self.class.name, (object_id * 2), to_sql, type.inspect, options.inspect]
          end
      
        end
    
      end
    end
  end
end