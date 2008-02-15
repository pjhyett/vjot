require File.dirname(__FILE__) + '/formats/email'

module DataMapper
  module Validations
    
    class FormatValidator < GenericValidator
      
      # Seems to me that all this email garbage belongs somewhere else...  Where's the best
      # place to stick it?
      include DataMapper::Validations::Helpers::Email

      ERROR_MESSAGES = {
        :invalid => '#{field} is invalid',
        :invalid_email => '#{value} is not a valid email address'
      }
            
      FORMATS = {
        :email_address => [lambda { |email_address| email_address =~ DataMapper::Validations::Helpers::Email::RFC2822::EmailAddress }, :invalid_email]
      }
      
      def initialize(field_name, options = {}, &b)
        @field_name, @options = field_name, options
      end

      def call(target)
        field_value = target.instance_variable_get("@#{@field_name}")
        return true if @options[:allow_nil] && field_value.nil?
        
        validation = (@options[:as] || @options[:with])
        message_key = :invalid
        
        # Figure out what to use as the actual validator.  If a symbol is passed to :as, look up
        # the canned validation in FORMATS.
        validator = if validation.is_a? Symbol
          if FORMATS[validation].is_a? Array
            message_key = FORMATS[validation][1] || :invalid
            FORMATS[validation][0]
          else
            FORMATS[validation] || validation
          end
        else
          validation
        end
        
        valid = case validator
        when Proc then validator.call(field_value)
        when Regexp then validator =~ field_value
        else raise UnknownValidationFormat, "Can't determine how to validate #{target.class}##{@field_name} with #{validator.inspect}"
        end 
        
        unless valid
          field = Inflector.humanize(@field_name)
          value = target.instance_variable_get("@#{@field_name}")
          
          error_message = validation_error_message(ERROR_MESSAGES[message_key], nil, binding)        
          add_error(target, error_message , @field_name)
        end
        
        return valid
      end
      
      class UnknownValidationFormat < StandardError
      end
      
    end
    
    module ValidatesFormatOf
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        # No bueno?
        DEFAULT_OPTIONS = { :on => :save }
        
        def validates_format_of(field, options = {})
          opts = retrieve_options_from_arguments_for_validators([options], DEFAULT_OPTIONS)
          validations.context(opts[:context]) << Validations::FormatValidator.new(field, opts)
        end

      end
    end
    
  end  
end
