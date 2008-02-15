module DataMapper
  module Validations
    
    class ConfirmationValidator < GenericValidator
      
      ERROR_MESSAGES = {
        :confirmation => '#{field} does not match the confirmation'
      }
      
      def initialize(field_name, options = {})
        @options = options
        @field_name, @confirm_field_name = field_name, (options[:confirm] || "#{field_name}_confirmation").to_sym
      end
      
      def call(target)
        field = Inflector.humanize(@field_name)

        unless valid?(target)
          error_message = validation_error_message(ERROR_MESSAGES[:confirmation], nil, binding)        
          add_error(target, error_message , @field_name)
          return false
        end
        
        return true
      end
      
      def valid?(target)
        field_value = target.instance_variable_get("@#{@field_name}")
        return true if @options[:allow_nil] && field_value.nil?

        confirm_value = target.instance_variable_get("@#{@confirm_field_name}")
        field_value == confirm_value
      end
      
    end
    
    module ValidatesConfirmationOf
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        # No bueno?
        DEFAULT_OPTIONS = { :on => :save }

        def validates_confirmation_of(field, options = {})
          opts = retrieve_options_from_arguments_for_validators([options], DEFAULT_OPTIONS)
          validations.context(opts[:context]) << Validations::ConfirmationValidator.new(field, opts)
        end

      end
    end
    
  end  
end
