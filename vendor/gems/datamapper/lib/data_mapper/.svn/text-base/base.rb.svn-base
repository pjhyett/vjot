require 'data_mapper/unit_of_work'
require 'data_mapper/support/active_record_impersonation'
require 'data_mapper/validations/validation_helper'
require 'data_mapper/associations'
require 'data_mapper/callbacks'

module DataMapper
  
  class Base
    
    # This probably needs to be protected
    attr_accessor :loaded_set, :fields
    
    include UnitOfWork
    include Support::ActiveRecordImpersonation
    include Validations::ValidationHelper
    include Associations
    
    def self.inherited(klass)
      klass.send(:undef_method, :id)
      
      # When this class is sub-classed, copy the declared columns.
      klass.class_eval do
        def self.inherited(subclass)
          
          database.schema[subclass.superclass].columns.each do |c|
            subclass.property(c.name, c.type, c.options)
            subclass.before_create do
              @type = self.class
            end if c.name == :type
          end
          
        end
      end
    end
    
    def self.set_table_name(value)
      database.schema[self].name = value
    end
    
    def initialize(details = nil)
      
      unless details.nil?
        details.reject do |key, value|
          protected_attribute? key
        end.each_pair do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
    
    def self.property(name, type, options = {})
      mapping = database.schema[self].add_column(name, type, options)
      property_getter(name, mapping)
      property_setter(name, mapping)
      return name
    end
    
    def self.property_getter(name, mapping)
      if mapping.lazy?
        class_eval <<-EOS
          def #{name}
            lazy_load!("#{name}")
          end
        EOS
      else
        class_eval("def #{name}; #{mapping.instance_variable_name} end")
      end
    end
    
    def self.property_setter(name, mapping)
      if mapping.lazy?
        class_eval <<-EOS
          def #{name.to_s.sub(/\?$/, '')}=(value)
            class << self;
              attr_accessor #{name.inspect}
            end
            @#{name} = value
          end
        EOS
      else
        class_eval("def #{name.to_s.sub(/\?$/, '')}=(value); #{mapping.instance_variable_name} = value end")
      end
    end
    
    def lazy_load!(name)
      (class << self; self end).send(:attr_accessor, name)
      
      column = session.schema[self.class][name.to_sym]
      
      # If the value is already loaded, then we don't need to do it again.
      value = instance_variable_get(column.instance_variable_name)
      return value unless value.nil?
      
      session.all(self.class, :select => [:id, name], :reload => true, :id => loaded_set.map(&:id)).each do |instance|
        (class << self; self end).send(:attr_accessor, name)
      end
      
      instance_variable_get(column.instance_variable_name)
    end
        
    def attributes
      session.schema[self.class].columns.inject({}) do |values, column|
        values[column.name] = instance_variable_get(column.instance_variable_name); values
      end
    end
    
    def attributes=(values_hash)
      values_hash.reject do |key, value|
        protected_attribute? key
      end.each_pair do |key, value|
        symbolic_instance_variable_set(key, value)
      end
    end
    
    def protected_attribute?(key)
      self.class.protected_attributes.include?(key.kind_of?(Symbol) ? key : key.to_sym)
    end
    
    def self.protected_attributes
      @protected_attributes ||= []
    end
    
    def self.protect(*keys)
      keys.each { |key| protected_attributes << key.to_sym }
    end
    
    def self.foreign_key
      Inflector.underscore(self.name) + "_id"
    end
    
    def inspect
      inspected_attributes = attributes.map { |k,v| "@#{k}=#{v.inspect}" }
      
      instance_variables.each do |name|
        if instance_variable_get(name).kind_of?(Associations::HasManyAssociation)
          inspected_attributes << "#{name}=#{instance_variable_get(name).inspect}"
        end
      end
      
      "#<%s:0x%x @new_record=%s, %s>" % [self.class.name, (object_id * 2), new_record?, inspected_attributes.join(', ')]
    end
    
    def session=(value)
      @session = value
    end
    
    def session
      @session || ( @session = database )
    end
    
    def key
      @__key || @__key = begin
        key_column = session.schema[self.class].key
        key_column.type_cast_value(instance_variable_get(key_column.instance_variable_name))
      end
    end
    
    # Callbacks associated with this class.
    def self.callbacks
      @callbacks || ( @callbacks = Callbacks.new )
    end
    
    # Declare helpers for the standard callbacks
    DataMapper::Callbacks::EVENTS.each do |name|
      class_eval <<-EOS
        def self.#{name}(string = nil, &block)
          if string.nil?
            callbacks.add(:#{name}, &block)
          else
            callbacks.add(:#{name}, string)
          end
        end
      EOS
    end
    
  end
  
end