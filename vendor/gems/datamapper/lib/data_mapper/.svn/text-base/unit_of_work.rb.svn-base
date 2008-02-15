module DataMapper
  
  # Should this track relations?
  module UnitOfWork

    def new_record?
      @new_record.nil? || @new_record
    end
    
    def dirty?(name = nil)
      if name.nil?
        session.schema[self.class].columns.any? { |column| self.instance_variable_get(column.instance_variable_name).hash != original_hashes[column.name] }
      else
        key = name.kind_of?(Symbol) ? name : name.to_sym
        self.instance_variable_get("@#{name}").hash != original_hashes[key]
      end
    end

    def dirty_attributes
      if new_record?
        session.schema[self.class].columns.reject do |column|
          instance_variable_get(column.instance_variable_name).nil?
        end
      else        
        session.schema[self.class].columns.select do |column|
          column.name != :id && instance_variable_get(column.instance_variable_name).hash != original_hashes[column.name]
        end
      end.inject({}) do |fields, column|
        fields[column.name] = instance_variable_get(column.instance_variable_name); fields
      end
    end
    
    def original_hashes
      @original_hashes || (@original_hashes = {})
    end
  end

end