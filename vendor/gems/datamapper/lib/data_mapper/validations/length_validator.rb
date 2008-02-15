module DataMapper
  module Validations
    
    class LengthValidator < GenericValidator
      
      ERROR_MESSAGES = {
        :range => '#{field} must be between #{min} and #{max} characters long',
        :min => '#{field} must be more than #{min} characters long',
        :max => '#{field} must be less than #{max} characters long',
        :equals => '#{field} must be #{equal} characters long'
      }
      
      def initialize(field_name, options)
        @field_name = field_name
        @options = options
        
        @min = options[:minimum] || options[:min]
        @max = options[:maximum] || options[:max]
        @equal = options[:is] || options[:equals]
        @range = options[:within] || options[:in]

        @validation_method ||= :range if @range
        @validation_method ||= :min if @min && @max.nil?
        @validation_method ||= :max if @max && @min.nil?
        @validation_method ||= :equals unless @equal.nil?
      end
      
      def call(target)
        field_value = target.instance_variable_get("@#{@field_name}").to_s
        return true if @options[:allow_nil] && field_value.nil?
        
        # HACK seems hacky to do this on every validation, probably should do this elsewhere?
        field = Inflector.humanize(@field_name)
        min = @range ? @range.min : @min
        max = @range ? @range.max : @max
        equal = @equal

        error_message = validation_error_message(ERROR_MESSAGES[@validation_method], nil, binding)
        
        valid = case @validation_method
        when :range then
          @range.include?(field_value.size)
        when :min then
          field_value.size >= min
        when :max then
          field_value.size <= max
        when :equals then
          field_value.size == equal
        end
        
        add_error(target, error_message, @field_name) unless valid

        return valid
      end

    end
    
    module ValidatesLengthOf
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        DEFAULT_VALIDATES_LENGTH_OF_OPTIONS = { :on => :save }

        def validates_length_of(field, options = {})
          opts = retrieve_options_from_arguments_for_validators([options], DEFAULT_VALIDATES_LENGTH_OF_OPTIONS)
          validations.context(opts[:context]) << Validations::LengthValidator.new(field, opts)
        end

      end
    end
    
  end  
end