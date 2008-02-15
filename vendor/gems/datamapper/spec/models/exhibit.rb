class Exhibit < DataMapper::Base
  property :name, :string
  
  belongs_to :zoo
  has_and_belongs_to_many :animals
end