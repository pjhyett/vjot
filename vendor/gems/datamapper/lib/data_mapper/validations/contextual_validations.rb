module DataMapper
  
  class ContextualValidations
    
    # This will be raised when you try to access
    # a context that's not a member of the DEFAULT_CONTEXTS array.
    class UnknownContextError < StandardError
    end
    
    # Add your custom contexts here.
    DEFAULT_CONTEXTS = [
        :general, :create, :save, :update
      ]
      
    def initialize
      @contexts = Hash.new { |h,k| h[k.to_sym] = [] }
    end
    
    # Retrieves a context by symbol.
    # Raises an exception if the symbol isn't a member of DEFAULT_CONTEXTS.
    # This isn't to keep you from adding your own contexts, it's just to
    # prevent errors due to typos. When adding your own contexts just
    # remember to add it to DEFAULT_CONTEXTS first.
    def context(name)
      raise UnknownContextError.new(name) unless DEFAULT_CONTEXTS.include?(name)
      @contexts[name]
    end
    
    # Clear out all the currently defined validators.
    # This makes testing easier.
    def clear!
      @contexts.clear
    end
    
    # Execute all validations against an instance for a specified context,
    # including the "always-on" :general context.
    def execute(context_name, target)
      target.errors.clear!
      
      validations = context(context_name)
      validations += context(:general) unless context_name == :general
      
      validations.inject(true) do |result, validator|
        result & validator.call(target)
      end
    end
      
  end
  
end