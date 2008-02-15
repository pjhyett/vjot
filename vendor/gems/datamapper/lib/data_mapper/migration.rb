module DataMapper
  class Migration
    class Table
      attr_accessor :name
      
      def initialize(table = nil)
        @name = table
        self.class.create(table) unless database.table_exists?(klass)
      end
      
      def self.create(table)
        puts "Creating table: #{table}"
        database.create_table klass(table)
      end
      
      def self.drop(table)
        puts "Dropping table: #{table}"
        database.drop_table klass(table)
      end
      
      def add(column, type, options = {})
        puts "+ #{column}"
      end
      
      def remove(column)
        puts "- #{column}"
      end
      
      # Rails Style
      
      def column(name, type, options = {})
        add(name, type, options)
      end
      
      # klass!
      
      def klass
        self.class.klass(self.name)
      end
      
      def self.klass(table)
        table_name = table.to_s
        class_name = Inflector::classify(table_name)
        klass = Inflector::constantize(class_name)
      rescue NameError
        module_eval <<-classdef
        class ::#{class_name} < DataMapper::Base
        end
        classdef
        klass = eval("#{class_name}")
      ensure
        klass
      end
      
    end
    class << self
      def up; end
      def down; end
      def migrate(direction = :up)
        send(direction)
      end
      def table(table = nil, options = {}, &block)
        if table && block
          table = DataMapper::Migration::Table.new(table)
          table.instance_eval &block
        else
          return DataMapper::Migration::Table
        end
      end
      # Rails Style
      def create_table(table_name, options = {}, &block)
        table.create(table_name)
        yield table.new(table_name)
      end
      
      def drop_table(table_name)
        table.drop(table_name)
      end
      
      def add_column(table_name, column, type, options = {})
        table table_name do
          add column, type, options
        end
      end
      
      def remove_column(table_name, column)
        table table_name do
          remove column
        end
      end
    end
  end
  
end