require 'logger'
require 'data_mapper/session'

# Delegates to DataMapper::database.
# Will not overwrite if a method of the same name is pre-defined.
def database(name = :default, &block)
  DataMapper::database(name, &block)
end unless methods.include?(:database)

module DataMapper
  
  # Block Syntax:
  #   Pushes the named database onto the context-stack, 
  #   yields a new session, and pops the context-stack.
  # Non-Block Syntax:
  #   Returns the current session, or if there is none,
  #   a new Session.
  def self.database(name = :default)
    unless block_given?
      Database.context.last || Session.new(Database[name].adapter)
    else
      Database.context.push(Session.new(Database[name].adapter))
      result = yield(Database.context.last)
      Database.context.pop
      result
    end
  end
  
  class DatabaseError < StandardError
    attr_accessor :options
  end
  
  class Database
    
    @databases = {}
    @context = []
    
    def self.[](name)
      @databases[name]
    end
    
    def self.context
      @context
    end
    
    def self.setup(name = :default, &initializer)
      current = self.new(name)
      current.instance_eval(&initializer)
      @databases[name] = current
    end
    
    def initialize(name)
      @name = name
    end
    
    attr_reader :name
    
    def adapter(value = nil)
      return @adapter if value.nil?
      
      raise ArgumentError.new('The adapter is readonly after being set') unless @adapter.nil?
      
      require "data_mapper/adapters/#{Inflector.underscore(value)}_adapter"
      adapter_class = Adapters::const_get(Inflector.classify(value) + "Adapter")
      
      @adapter = adapter_class.new(self)
    end
    
    def host(value = nil); value.nil? ? (@host || 'localhost') : @host = value end
    def database(value = nil); value.nil? ? @database : @database = value end
    def username(value = nil); value.nil? ? @username : @username = value end
    def password(value = nil); value.nil? ? (@password || '') : @password = value end
    
    def log(value = nil)
      @log = value unless value.nil?

      if @log.nil?
        @log = log_stream.nil? ? Logger.new(nil) : Logger.new(log_stream, File::WRONLY | File::APPEND | File::CREAT)
        @log.level = log_level || Logger::WARN
        at_exit { @log.close }
      end
      
      @log
    end
    
    def log_level(value = nil)
      return @log_level if value.nil?
      @log_level = value
    end
    
    def log_stream(value = nil)
      return @log_stream if value.nil?
      @log_stream = value
    end
    
  end
  
end