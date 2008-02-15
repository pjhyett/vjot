require 'data_mapper/adapters/abstract_adapter'
require 'data_mapper/adapters/sql/commands/load_command'
require 'data_mapper/adapters/sql/commands/save_command'
require 'data_mapper/adapters/sql/commands/delete_command'
require 'data_mapper/adapters/sql/commands/table_exists_command'
require 'data_mapper/adapters/sql/coersion'
require 'data_mapper/adapters/sql/quoting'
require 'data_mapper/adapters/sql/mappings/schema'

module DataMapper
  
  # An Adapter is really a Factory for three types of object,
  # so they can be selectively sub-classed where needed.
  # 
  # The first type is a Query. The Query is an object describing
  # the database-specific operations we wish to perform, in an
  # abstract manner. For example: While most if not all databases
  # support a mechanism for limiting the size of results returned,
  # some use a "LIMIT" keyword, while others use a "TOP" keyword.
  # We can set a SelectStatement#limit field then, and allow
  # the adapter to override the underlying SQL generated.
  # Refer to DataMapper::Queries.
  # 
  # The second type provided by the Adapter is a DataMapper::Connection.
  # This allows us to execute queries and return results in a clear and
  # uniform manner we can use throughout the DataMapper.
  #
  # The final type provided is a DataMapper::Transaction.
  # Transactions are duck-typed Connections that span multiple queries.
  #
  # Note: It is assumed that the Adapter implements it's own
  # ConnectionPool if any since some libraries implement their own at
  # a low-level, and it wouldn't make sense to pay a performance
  # cost twice by implementing a secondary pool in the DataMapper itself.
  # If the library being adapted does not provide such functionality,
  # DataMapper::Support::ConnectionPool can be used.
  module Adapters
      
    # You must inherit from the SqlAdapter, and implement the
    # required methods to adapt a database library for use with the DataMapper.
    #
    # NOTE: By inheriting from SqlAdapter, you get a copy of all the
    # standard sub-modules (Quoting, Coersion and Queries) in your own Adapter.
    # You can extend and overwrite these copies without affecting the originals.
    class SqlAdapter < AbstractAdapter
      
      FIND_OPTIONS = [
        :select, :limit, :class, :include, :reload, :conditions, :order
      ]
         
      def connection(&block)
        raise NotImplementedError.new
      end
  
      def transaction(&block)
        raise NotImplementedError.new
      end
      
      def schema
        @schema || ( @schema = Mappings::Schema.new(self) )
      end
      
      def table_exists?(name)
        self.class::Commands::TableExistsCommand.new(self, name).call
      end
      
      def delete(klass_or_instance, options = nil)
        self.class::Commands::DeleteCommand.new(self, klass_or_instance, options).call
      end
      
      def save(session, instance)
        self.class::Commands::SaveCommand.new(self, session, instance).call
      end
      
      def load(session, klass, options)
        self.class::Commands::LoadCommand.new(self, session, klass, options).call
      end
      
      def [](klass_or_table_name)
        schema[klass_or_table_name]
      end
      
      # This callback copies and sub-classes modules and classes
      # in the AbstractAdapter to the inherited class so you don't
      # have to copy and paste large blocks of code from the
      # SqlAdapter.
      # 
      # Basically, when inheriting from the AbstractAdapter, you
      # aren't just inheriting a single class, you're inheriting
      # a whole graph of Types. For convenience.
      def self.inherited(base)
        
        queries = base.const_set('Commands', Module.new)

        Sql::Commands.constants.each do |name|
          queries.const_set(name, Class.new(Sql::Commands.const_get(name)))
        end  
        
        base.const_set('TYPES', TYPES.dup)
        base.const_set('FIND_OPTIONS', FIND_OPTIONS.dup)
        
        super
      end
      
      TYPES = {
        :integer => 'int'.freeze,
        :string => 'varchar'.freeze,
        :text => 'text'.freeze,
        :class => 'varchar'.freeze
      }

      include Sql
      include Quoting
      include Coersion
      
    end # class SqlAdapter
    
  end # module Adapters
end # module DataMapper