module DataMapper
  module Adapters
      
    class AbstractAdapter
  
      # Instantiate an Adapter by passing it a DataMapper::Database
      # object for configuration.
      def initialize(configuration)
        @configuration = configuration
      end
      
      def delete(instance_or_klass, options = nil)
        raise NotImplementedError.new
      end
      
      def save(session, instance)
        raise NotImplementedError.new
      end
      
      def load(session, klass, options)
        raise NotImplementedError.new
      end
      
      def log
        @configuration.log
      end
      
    end # class AbstractAdapter
    
  end # module Adapters
end # module DataMapper