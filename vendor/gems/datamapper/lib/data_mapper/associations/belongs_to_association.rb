module DataMapper
  module Associations
    
    class BelongsToAssociation
      
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
        foreign_key = options[:foreign_key] || ("#{association_name}_id")
        klass.property foreign_key.to_sym, :integer
        
        # Define the association instance method (i.e. Exhibit#zoo)
        klass.class_eval <<-EOS
          def create_#{association_name}(options = {})
            #{association_name}_association.create(options)
          end
          
          def build_#{association_name}(options = {})
            #{association_name}_association.build(options)
          end
          
          def #{association_name}
            # Let the BelongsToAssociation do the finding, just to keep things neat around here...
            #{association_name}_association.find
          end
          
          def #{association_name}=(value)
            #{association_name}_association.set(value)
          end
          
          private
            def #{association_name}_association
              @#{association_name} || (@#{association_name} = BelongsToAssociation.new(self, "#{association_name}", #{options.inspect}))
            end
        EOS
        
      end
      
      def find
        return @result unless @result.nil?
        
        unless @instance.loaded_set.nil?
          
          # Temp variable for the instance variable name.
          setter_method = "#{@association_name}=".to_sym
          instance_variable_name = "@#{foreign_key}".to_sym
          
          set = @instance.loaded_set.group_by { |instance| instance.instance_variable_get(instance_variable_name) }
          
          # Fetch the foreign objects for all instances in the current object's loaded-set.
          @instance.session.all(@associated_class, :id => set.keys).each do |owner|
            set[owner.key].each do |instance|
              instance.send(setter_method, owner)
            end
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
        @foreign_key ||= (@options[:foreign_key] || @instance.session.schema[@associated_class].default_foreign_key)
      end
            
    end
    
    module BelongsTo
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def belongs_to(association_name, options = {})
          BelongsToAssociation.setup(self, association_name, options)
        end
      end
    end
    
  end
end