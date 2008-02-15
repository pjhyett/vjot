class Jot < DataMapper::Base
  property   :title, :string
  property   :body,  :text, :lazy => false
  belongs_to :user
end
