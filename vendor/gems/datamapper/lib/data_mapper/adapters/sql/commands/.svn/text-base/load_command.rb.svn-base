require File.dirname(__FILE__) + '/conditions'
require 'inline'

module DataMapper
  module Adapters
    module Sql
      module Commands
    
        class LoadCommand
      
          attr_reader :klass, :order, :limit, :instance_id, :conditions, :options
          
          def initialize(adapter, session, klass, options)
            @adapter, @session, @klass, @options = adapter, session, klass, options
            
            @order = @options[:order]
            @limit = @options[:limit]
            @reload = @options[:reload]
            @instance_id = @options[:id]
            @conditions = Conditions.new(@adapter, self)
          end
          
          def reload?
            @reload
          end

          def escape(conditions)
            @adapter.escape(conditions)
          end
      
          def inspect
            @options.inspect
          end
      
          def include?(association_name)
            return false if includes.empty?
            includes.include?(association_name)
          end
      
          def includes
            @includes || @includes = begin
              list = @options[:include] || []
              list.kind_of?(Array) ? list : [list]
              list
            end
          end
      
          def select
            @select_columns || @select_columns = begin
              select_columns = @options[:select]
              unless select_columns.nil?
                select_columns = select_columns.kind_of?(Array) ? select_columns : [select_columns]
                select_columns.map { |column| @adapter.quote_column_name(column.to_s) }
              else
                STDERR.puts @adapter[klass].columns.inspect
                @options[:select] = @adapter[klass].columns.select do |column|
                  STDERR.puts "c: #{column.name} l: #{column.lazy?}"
                  include?(column.name) || !column.lazy?
                end.map { |column| column.to_sql }
              end
            end
          end
      
          def table_name
            @table_name || @table_name = if @options.has_key?(:table)
              @adapter.quote_table_name(@options[:table])
            else
              @adapter[klass].to_sql
            end
          end
          
          def to_sql
            return @options[:sql] if @options.has_key?(:sql)
            
            sql = 'SELECT ' << select.join(', ') << ' FROM ' << table_name
        
            where = []
        
            where += conditions.to_a unless conditions.empty?
        
            unless where.empty?
              sql << ' WHERE (' << where.join(') AND (') << ')'
            end
        
            unless order.nil?
              sql << ' ORDER BY ' << order.to_s
            end
        
            unless limit.nil?
              sql << ' LIMIT ' << limit.to_s
            end
        
            return sql
          end
          
          def call
            
            if @klass == Struct
              reader = execute(to_sql)
              results = fetch_structs(reader)
              close_reader(reader)
              return results              
            end
            
            if instance_id && !reload?
              if instance_id.kind_of?(Array)
                instances = instance_id.map do |id|
                  @session.identity_map.get(klass, id)
                end.compact
              
                return instances if instances.size == instance_id.size
              else
                instance = @session.identity_map.get(klass, instance_id)
                return instance unless instance.nil?
              end
            end
          
            reader = execute(to_sql)
          
            results = if eof?(reader)
              nil
            elsif limit == 1 || ( instance_id && !instance_id.kind_of?(Array) )
              fetch_one(reader)
            else
              fetch_all(reader)
            end
            
            close_reader(reader)
            
            return results
          end

          def load(hash, set = [])

            instance_class = unless hash['type'].nil?
              Kernel::const_get(hash['type'])
            else
              klass
            end

            mapping = @adapter[instance_class]

            instance_id = mapping.key.type_cast_value(hash['id'])   
            instance = @session.identity_map.get(instance_class, instance_id)

            if instance.nil? || reload?
              instance ||= instance_class.new
              instance.class.callbacks.execute(:before_materialize, instance)

              instance.instance_variable_set(:@new_record, false)
              STDERR.puts hash.inspect
              hash.each_pair do |name_as_string,raw_value|
                STDERR.puts name_as_string.inspect
                name = name_as_string.to_sym
                if column = mapping.find_by_column_name(name)
                  value = column.type_cast_value(raw_value)
                  instance.instance_variable_set(column.instance_variable_name, value)
                else
                  instance.instance_variable_set("@#{name}", value)
                end
                instance.original_hashes[name] = value.hash
              end
              
              instance.instance_variable_set(:@__key, instance_id)
              
              instance.class.callbacks.execute(:after_materialize, instance)
              
              STDERR.puts instance.inspect

              @session.identity_map.set(instance)
            end
            
            STDERR.puts instance.inspect
            STDERR.puts set.inspect

            instance.instance_variable_set(:@loaded_set, set)
            instance.session = @session
            set << instance
            return instance
          end
          
          def load_instances(fields, rows)            
            table = @adapter[klass]
            
            set = []
            columns = {}
            key_ordinal = nil
            key_column = table.key
            type_ordinal = nil
            type_column = nil
            
            fields.each_with_index do |field, i|
              STDERR.puts field.inspect
              column = table.find_by_column_name(field.to_sym)
              key_ordinal = i if column.key?
              type_ordinal, type_column = i, column if column.name == :type
              columns[column] = i
            end
            
            if type_ordinal
              
              tables = Hash.new() do |h,k|
                
                table_for_row = @adapter[k.blank? ? klass : type_column.type_cast_value(k)]
                key_ordinal_for_row = nil
                columns_for_row = {}
                
                fields.each_with_index do |field, i|
                  column = table_for_row.find_by_column_name(field.to_sym)
                  key_ordinal_for_row = i if column.key?
                  columns_for_row[column] = i
                end
                
                h[k] = [ table_for_row.klass, table_for_row.key, key_ordinal_for_row, columns_for_row ]
              end
              
              rows.each do |row|
                klass_for_row, key_column_for_row, key_ordinal_for_row, columns_for_row = *tables[row[type_ordinal]]
                
                load_instance(
                  create_instance(
                    klass_for_row,
                    key_column_for_row.type_cast_value(row[key_ordinal_for_row])
                  ),
                  columns_for_row,
                  row,
                  set
                )
              end
            else
              rows.each do |row|
                load_instance(
                  create_instance(
                    klass,
                    key_column.type_cast_value(row[key_ordinal])
                  ),
                  columns,
                  row,
                  set
                )
              end
            end
            
            set.dup
          end
          
          # Create an instance for the specified Class and id in
          # preparation for loading. This method first checks to
          # see if the instance is in the IdentityMap.
          # If not, then a new class is created, it's marked as
          # not-new, the key is set and it's added to the IdentityMap.
          # Afterwards the instance's Session is updated to the current
          # session, and the instance returned.
          def create_instance(instance_class, instance_id)
            instance = @session.identity_map.get(instance_class, instance_id)
            
            if instance.nil? || reload?
              instance = instance_class.new()
              instance.instance_variable_set(:@__key, instance_id)
              instance.instance_variable_set(:@new_record, false)
              @session.identity_map.set(instance)
            end
            
            instance.session = @session
            
            return instance
          end
          
          def load_instance(instance, columns, values, set = [])
            
            instance.class.callbacks.execute(:before_materialize, instance)
            
            hashes = {}
            
            columns.each_pair do |column, i|
              hashes[column.name] = instance.instance_variable_set(
                column.instance_variable_name,
                column.type_cast_value(values[i])
              ).hash
            end
            
            instance.instance_variable_set(:@original_hashes, hashes)
            
            instance.instance_variable_set(:@loaded_set, set)
            set << instance
            
            instance.class.callbacks.execute(:after_materialize, instance)
            
            return instance
          end
          
          def load_structs(columns, reader)
            results = []
            
            ordered_columns = columns.keys
            struct = Struct.new(*ordered_columns.map { |c| c.to_sym })
            
            reader.each do |row|
              results << struct.new(*ordered_columns.map do |column|
                row[columns[column]]
              end)
            end
            
            results
          end

          protected
          def count_rows(reader)
            raise NotImplementedError.new
          end

          def close_reader(reader)
            raise NotImplementedError.new
          end

          def execute(sql)
            raise NotImplementedError.new
          end

          def fetch_one(reader)
            raise NotImplementedError.new
          end

          def fetch_all(reader)
            raise NotImplementedError.new
          end

          def fetch_structs(reader)
            raise NotImplementedError.new
          end
          
        end # class LoadCommand
      end # module Commands
    end # module Sql
  end # module Adapters
end # module DataMapper