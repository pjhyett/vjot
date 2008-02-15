describe DataMapper::Adapters::Sql::Commands::SaveCommand do
  
  it "should create a new row" do
    Zoo.create({ :name => 'bob' })
  end
  
  it "should update an existing row" do
    dallas = Zoo[:name => 'Dallas']
    dallas.name = 'bob'
    dallas.save
  end
  
end