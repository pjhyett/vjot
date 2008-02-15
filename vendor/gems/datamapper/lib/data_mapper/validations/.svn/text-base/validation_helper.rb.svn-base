dirname = File.dirname(__FILE__)

require dirname + '/validation_errors'
require dirname + '/contextual_validations'
require dirname + '/generic_validator'

Dir[dirname + '/*_validator.rb'].reject do |path|
  path =~ /\/generic_validator/
end.each do |validator|
  load validator
end

module DataMapper
  module Validations
    
    module ValidationHelper
      
      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          include DataMapper::Validations::ValidatesPresenceOf
          include DataMapper::Validations::ValidatesLengthOf
          include DataMapper::Validations::ValidatesConfirmationOf
          include DataMapper::Validations::ValidatesUniquenessOf
          include DataMapper::Validations::ValidatesFormatOf
        end
      end
      
      def errors
        @errors ||= ValidationErrors.new
      end
      
      def valid?(context = :general)
        self.class.validations.execute(context, self)
      end
      
      module ClassMethods
        
        def validations
          @validations ||= ContextualValidations.new
        end
        
        def retrieve_options_from_arguments_for_validators(args, defaults = nil)
          options = args.last.kind_of?(Hash) ? args.pop : {}
          
          context = :general
          context = options[:context] if options.has_key?(:context)
          context = options.delete(:on) if options.has_key?(:on)
          options[:context] = context
          
          options.merge!(defaults) unless defaults.nil?
          return options
        end
                
      end
      
    end    
    
  end
end