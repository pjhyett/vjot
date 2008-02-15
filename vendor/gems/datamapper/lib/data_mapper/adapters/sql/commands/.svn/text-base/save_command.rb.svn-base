module DataMapper
  module Adapters
    module Sql
      module Commands
    
        class SaveCommand
      
          def initialize(adapter, session, instance)
            @adapter, @session, @instance = adapter, session, instance
          end
      
          def to_update_sql
            table = @adapter[@instance.class]
        
            sql = "UPDATE " << table.to_sql << " SET "
        
            @instance.dirty_attributes.map do |k, v|
              sql << table[k].to_sql << " = " << @adapter.quote_value(v) << ", "
            end
        
            sql[0, sql.size - 2] << " WHERE #{table.key.to_sql} = " << @adapter.quote_value(@instance.key)
          end
          
          def to_insert_sql
        
            table = @adapter[@instance.class]
        
            keys = []
            values = []
        
            @instance.dirty_attributes.each_pair { |k,v| keys << table[k].to_sql; values << v }
        
            # Formatting is a bit off here, but it looks nicer in the log this way.
            sql = "INSERT INTO #{table.to_sql} (#{keys.join(', ')}) \
    VALUES (#{values.map { |v| @adapter.quote_value(v) }.join(', ')})"
          end
          
          def to_create_table_sql
            table = @adapter[@instance]
        
            sql = "CREATE TABLE " << table.to_sql << " ("
        
            sql << table.columns.map do |column|
              column_long_form(column)
            end.join(', ')
        
            sql << ", PRIMARY KEY (#{table.key.to_sql}))"
        
            return sql
          end
      
          def column_long_form(column)
            long_form = "#{column.to_sql} #{@adapter.class::TYPES[column.type] || column.type}"
        
            long_form << "(#{column.size})" unless column.size.nil?
            long_form << " NOT NULL" unless column.nullable?
            long_form << " auto_increment" if column.key?
            long_form << " default #{column.options[:default]}" if column.options.has_key?(:default)
        
            return long_form
          end
          
          def callback(name)
            @instance.class.callbacks.execute(name, @instance)
          end
          
          def insert!
            callback(:before_create)
            
            result = execute_insert(to_insert_sql)
            
            if result
              @instance.instance_variable_set(:@new_record, false)
              @instance.instance_variable_set(:@id, result)
              calculate_original_hashes(@instance)
              @session.identity_map.set(@instance)
              callback(:after_create)
            end

            return result
          rescue => error
            @adapter.log.error(error)
            raise error
          end

          def update!
            callback(:before_update)
            
            result = execute_update(to_update_sql)
            
            calculate_original_hashes(@instance)
            callback(:after_update)
            return result
          rescue => error
            @adapter.log.error(error)
            raise error
          end
          
          def call
            if @instance.kind_of?(Class)
              return false if @adapter.table_exists?(@instance)
              execute_create_table(to_create_table_sql)
            else
              return false unless @instance.dirty?
              callback(:before_save)
              result = @instance.new_record? ? insert! : update!
              @instance.session = @session
              callback(:after_save)
              result
            end
          end
          
          protected
          def execute_insert(sql)
            raise NotImplementedError.new
          end
          
          def execute_update(sql)
            raise NotImplementedError.new
          end
          
          def execute_create_table(sql)
            raise NotImplementedError.new
          end
          
          private
          # Calculates the original hashes for each value
          # in an instance's set of attributes, and adds
          # them to the original_hashes hash.
          def calculate_original_hashes(instance)
            instance.attributes.each_pair do |name, value|
              instance.original_hashes[name] = value.hash
            end
          end
      
        end
    
      end
    end
  end
end