class User < DataMapper::Base
  property :name,     :string
  property :password, :string
  has_many :jots
  
  def to_s() name end
  
  validates_uniqueness_of :name
  validates_length_of :name, :in => 1..200
end
