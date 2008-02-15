module DataMapper
  module Associations
    
    class HasManyAssociation
      include Enumerable
      
      def initialize(instance, association_name, options)
        @instance = instance
        @association_name = association_name.to_sym
        @options = options
        
        @associated_class = if options.has_key?(:class) || options.has_key?(:class_name)
          associated_class_name = (options[:class] || options[:class_name])
          if associated_class_name.kind_of?(String)
            Kernel.const_get(Inflector.classify(associated_class_name))
          else
            associated_class_name
          end
        else            
          Kernel.const_get(Inflector.classify(association_name))
        end
      end
      
      def self.setup(klass, association_name, options)
        
        # Define the association instance method (i.e. Project#tasks)
        klass.class_eval <<-EOS
          def #{association_name}
            @#{association_name} || (@#{association_name} = HasManyAssociation.new(self, "#{association_name}", #{options.inspect}))
          end
        EOS
        
      end
      
      def each
        find.each { |item| yield item }
      end
      
      def size
        entries.size
      end
      alias length size
      
      def [](key)
        entries[key]
      end
      
      def empty?
        entries.empty?
      end
      
      def find
        return @results unless @results.nil?
        
        unless @instance.loaded_set.nil?
          
          # Temp variable for the instance variable name.
          instance_variable_name = "@#{foreign_key}".to_sym
          
          set = @instance.loaded_set.group_by { |instance| instance.key }
          
          # Fetch the foreign objects for all instances in the current object's loaded-set.
          @instance.session.all(@associated_class, foreign_key.to_sym => set.keys).group_by do |association|
            association.instance_variable_get(instance_variable_name)
          end.each_pair do |id, results|
            set[id].first.send(@association_name).set(results)
          end
          
        end
        
        return @results ||= []
      end
      
      def set(results)
        @results = results
      end
      
      def inspect
        @results.inspect
      end
      
      def foreign_key
        @foreign_key || (@foreign_key = (@options[:foreign_key] || @instance.session.schema[@instance.class].default_foreign_key))
      end

    end
    
    module HasMany
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def has_many(association_name, options = {})
          HasManyAssociation.setup(self, association_name, options)
        end
      end
    end
    
  end
end