module DataMapper
  module Associations
    
    class HasAndBelongsToManyAssociation
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
        
        @join_table_name = @options.has_key?(:join_table_name) ? @options[:join_table_name] : [Inflector.tableize(@instance.class.name), Inflector.tableize(@associated_class.name)].sort.join('_')
      end
      
      def self.setup(klass, association_name, options)
        
        # Define the association instance method (i.e. Project#tasks)
        klass.class_eval <<-EOS
          def #{association_name}
            @#{association_name} || (@#{association_name} = HasAndBelongsToManyAssociation.new(self, "#{association_name}", #{options.inspect}))
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
          
          @results = @instance.session.find(@associated_class, :all,
            :id.select => { :table => @join_table_name, foreign_key.to_sym => @instance.key }
          ) do |animal_id, ref|
            @instance.load_set.find { |x| x.id == animal_id }.exhibits << ref
          end
          
        end
        
        return @results || (@results = [])
      end
      
      def set(results)
        @results = results
      end
      
      def inspect
        @results.inspect
      end
      
      def foreign_key
        @foreign_key || (@foreign_key = (@options[:foreign_key] || @instance.session.mappings[@instance.class].default_foreign_key))
      end

    end
    
    module HasAndBelongsToMany
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def has_and_belongs_to_many(association_name, options = {})
          HasAndBelongsToManyAssociation.setup(self, association_name, options)
        end
      end
    end
    
  end
end