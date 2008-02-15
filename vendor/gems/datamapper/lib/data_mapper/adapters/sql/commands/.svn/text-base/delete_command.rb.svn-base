module DataMapper
  module Adapters
    module Sql
      module Commands
    
        class DeleteCommand
      
          def initialize(adapter, klass_or_instance, options = nil)
            @adapter, @klass_or_instance, @options = adapter, klass_or_instance, options
          end
      
          def truncate?
            return false if @options.nil?
            @options[:truncate]
          end
          
          def drop?
            return false if @options.nil?
            @options[:drop]
          end
          
          def delete_all?
            return !truncate? && !drop? && @klass_or_instance.kind_of?(Class)
          end
          
          def klass
            @klass_or_instance.kind_of?(Class) ? @klass_or_instance : @klass_or_instance.class
          end
          
          def to_truncate_sql
            "TRUNCATE TABLE " << @adapter[@klass_or_instance].to_sql
          end
          
          def to_drop_sql
            "DROP TABLE #{@adapter[@klass_or_instance].to_sql}"
          end
          
          def to_delete_sql
            sql = "DELETE FROM " << @adapter[klass].to_sql
            sql << " WHERE id = " << @adapter.quote_value(@klass_or_instance.key) unless delete_all?
            return sql
          end
          
          def to_sql
            if truncate?
              to_truncate_sql
            elsif drop?
              to_drop_sql
            else
              to_delete_sql
            end
          end
          
          def session
            return nil if @options.nil?
            @options[:session]
          end
          
          def call
            result = nil
            
            if truncate?
              result = execute_truncate(to_sql)
              session.identity_map.clear!(klass) unless session.nil?
            elsif drop?
              result = execute_drop(to_sql)
              session.identity_map.clear!(klass) unless session.nil?
            elsif delete_all?
              result = execute_delete_all(to_sql)
              session.identity_map.clear!(klass) unless session.nil?
            else
              @klass_or_instance.class.callbacks.execute(:before_destroy, @klass_or_instance)
              
              result = execute(to_sql)
              
              if result
                @klass_or_instance.instance_variable_set(:@new_record, true)
                @klass_or_instance.session = session
                @klass_or_instance.original_hashes.clear
                session.identity_map.delete(@klass_or_instance) unless session.nil?
                @klass_or_instance.class.callbacks.execute(:after_destroy, @klass_or_instance)
              end
            end
            
            return result
          rescue => error
            @adapter.log.error(error)
            raise error
          end
          
          protected
          def execute_truncate(sql)
            execute(sql)
          end
          
          def execute_drop(sql)
            execute(sql)
          end
          
          def execute_delete_all(sql)
            execute(sql)
          end
          
          def execute(sql)
            raise NotImplementedError.new
          end
          
        end
    
      end
    end
  end
end