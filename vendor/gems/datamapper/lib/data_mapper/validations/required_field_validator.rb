module DataMapper
  module Validations
    
    class RequiredFieldValidator < GenericValidator
      
      ERROR_MESSAGES = {
        :required => '#{field} must not be blank'
      }
      
      def initialize(field_name)
        @field_name = field_name
      end
      
      def call(target)
        field_value = !target.instance_variable_get("@#{@field_name}").nil?
        return true if field_value
        
        field = Inflector.humanize(@field_name)
        
        error_message = validation_error_message(ERROR_MESSAGES[:required], nil, binding)        
        add_error(target, error_message , @field_name)
        
        return false
      end
      
    end
    
    module ValidatesPresenceOf
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods

        def validates_presence_of(*fields)
          options = retrieve_options_from_arguments_for_validators(fields)
          
          fields.each do |field|
            validations.context(options[:context]) << Validations::RequiredFieldValidator.new(field)
          end
        end

      end
    end
    
  end  
end
