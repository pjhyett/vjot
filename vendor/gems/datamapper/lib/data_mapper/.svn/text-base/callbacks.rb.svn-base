module DataMapper
  
  class Callbacks
  
    EVENTS = [
      :before_materialize, :after_materialize,
      :before_save, :after_save,
      :before_create, :after_create,
      :before_update, :after_update,
      :before_destroy, :after_destroy,
      :before_validate, :after_validate
      ]
      
    def initialize
      @callbacks = Hash.new do |h,k|
        raise 'Callback names must be Symbols' unless k.kind_of?(Symbol)
        h[k] = []
      end
    end
    
    alias ruby_method_missing method_missing
    def method_missing(sym, *args)
      if EVENTS.include?(sym)
        self.class.send(:define_method, sym) { @callbacks[sym] }
        return send(sym)
      elsif sym.to_s =~ /^execute_(\w+)/ && EVENTS.include?($1.to_sym)
        return execute(args.first, $1.to_sym)
      end
      
      super
    end
    
    def execute(name, instance)
      @callbacks[name].each do |callback|
        if callback.kind_of?(String)
          instance.instance_eval(callback)
        else
          instance.instance_eval(&callback)
        end
      end
    end
    
    def add(name, string = nil, &block)
      callback = send(name)
      raise ArgumentError.new("You didn't specify a callback in either string or block form.") if string.nil? && block.nil?
      callback << (string.nil? ? block : string)
    end
  end
  
end