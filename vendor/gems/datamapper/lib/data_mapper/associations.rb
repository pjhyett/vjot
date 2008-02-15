require 'data_mapper/associations/has_many_association'
require 'data_mapper/associations/belongs_to_association'
require 'data_mapper/associations/has_one_association'
require 'data_mapper/associations/has_and_belongs_to_many_association'

module DataMapper
  module Associations
  
    def self.included(base)
      base.class_eval do
        include DataMapper::Associations::HasMany
        include DataMapper::Associations::BelongsTo
        include DataMapper::Associations::HasOne
        include DataMapper::Associations::HasAndBelongsToMany
      end
    end
    
  end
end