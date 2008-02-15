module DataMapper
  module Validations
    
    # All Validators should inherit from the GenericValidator.
    class GenericValidator
    
      # Adds an error message to the target class.
      def add_error(target, message, attribute = :base)
        target.errors.add(attribute, message)
      end
      
      # Gets the proper error message
      def validation_error_message(default, custom_message, validation_binding)
        eval("\"#{(custom_message || default)}\"", validation_binding)
      end
      
      # Call the validator. We use "call" so the operation
      # is BoundMethod and Block compatible.
      # The result should always be TRUE or FALSE.
      def call(target)
        raise 'You must overwrite this method'
      end
      
    end
        
  end
end