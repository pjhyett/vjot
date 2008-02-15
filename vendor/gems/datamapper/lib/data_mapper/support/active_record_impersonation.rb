module DataMapper
  module Support
    
    module ActiveRecordImpersonation
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      def save
        session.save(self)
      end
      
      def reload!
        session.first(self.class, key, :select => session.mappings[self.class].columns.map(&:name), :reload => true)
      end
      
      def reload
        reload!
      end
      
      def destroy!
        session.destroy(self)
      end
      
      module ClassMethods
        
        def all(options = {}, &b)
          database.all(self, options, &b)
        end
        
        def first(*args, &b)
          database.first(self, *args, &b)
        end
        
        def delete_all
          database.delete_all(self)
        end
        
        def truncate!
          database.truncate(self)
        end
        
        def find(type_or_id, options = {}, &b)
          case type_or_id
            when :first then first(options, &b)
            when :all then all(options, &b)
            else first(type_or_id, options, &b)
          end
        end
        
        def find_by_sql(*args)
          DataMapper::database.query(*args)
        end
        
        def [](id_or_hash)
          first(id_or_hash)
        end
        
        def create(attributes)
          instance = self.new(attributes)
          instance.save
          instance
        end
      end
    end
    
  end
end