module DataMapper
  module Associations
    
    class HasOneAssociation
      
      def initialize(instance, association_name, options)
        @instance = instance
        @association_name = association_name
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
        
        # Define the association instance method (i.e. Exhibit#zoo)
        klass.class_eval <<-EOS
          def create_#{association_name}(options = {})
            #{association_name}_association.create(options)
          end
          
          def build_#{association_name}(options = {})
            #{association_name}_association.build(options)
          end

          def #{association_name}
            # Let the HasOneAssociation do the finding, just to keep things neat around here...
            #{association_name}_association.find
          end
          
          def #{association_name}=(value)
            #{association_name}_association.set(value)
          end
          
          private
            def #{association_name}_association
              @#{association_name} || (@#{association_name} = HasOneAssociation.new(self, "#{association_name}", #{options.inspect}))
            end
        EOS
        
      end
      
      def find
        return @result unless @result.nil?
        
        unless @instance.loaded_set.nil?
          
          # Temp variable for the instance variable name.
          setter_method = "#{@association_name}=".to_sym
          instance_variable_name = "@#{foreign_key}".to_sym
          
          set = @instance.loaded_set.group_by { |instance| instance.key }
          
          # Fetch the foreign objects for all instances in the current object's loaded-set.
          @instance.session.all(@associated_class, foreign_key => set.keys).each do |association|
            set[association.instance_variable_get(instance_variable_name)].first.send(setter_method, association)
          end
        end
        
        return @result
      end

      def create(options = {})
        associated = @associated_class.new(options)
        if associated.save
          @instance.send("#{@associated_class.foreign_key}=", associated.id)
          @result = associated
        end
      end
      
      def build(options = {})
        @result = @associated_class.new(options)
      end
      
      def set(val)
        @result = val
      end
      
      def foreign_key
        @foreign_key ||= (@options[:foreign_key] || @instance.session.mappings[@instance.class].default_foreign_key)
      end
            
    end
    
    module HasOne
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def has_one(association_name, options = {})
          HasOneAssociation.setup(self, association_name, options)
        end
      end
    end
    
  end
end