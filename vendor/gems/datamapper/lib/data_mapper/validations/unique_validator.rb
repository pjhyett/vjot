module DataMapper
  module Validations
    
    class UniqueValidator < GenericValidator
      
      ERROR_MESSAGES = {
        :unique => '#{field} has already been taken'
      }
      
      def initialize(field_name, options = {})
        @options = options
        @field_name = field_name.to_sym
      end
      
      def call(target)
        field = Inflector.humanize(@field_name)

        unless valid?(target)
          error_message = validation_error_message(ERROR_MESSAGES[:unique], nil, binding)        
          add_error(target, error_message , @field_name)
          return false
        end
        
        return true
      end
      
      def valid?(target)
        field_value = target.instance_variable_get("@#{@field_name}")
        return true if @options[:allow_nil] && field_value.nil?
        
        finder_options = { @field_name => field_value }
        
        if @options[:scope]
          scope_value = target.instance_variable_get("@#{@options[:scope]}")
          finder_options.merge! @options[:scope] => scope_value
        end
        
        finder_options.merge!({ target.session.mappings[target.class].key.name.not => target.key }) unless target.new_record?
        
        target.session.first(target.class, finder_options).nil?
      end
      
    end
    
    module ValidatesUniquenessOf
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        # No bueno?
        DEFAULT_OPTIONS = { :on => :save }

        def validates_uniqueness_of(field, options = {})
          opts = retrieve_options_from_arguments_for_validators([options], DEFAULT_OPTIONS)
          validations.context(opts[:context]) << Validations::UniqueValidator.new(field, opts)
        end

      end
    end
    
  end  
end
