describe DataMapper::Adapters::Sql::Commands::LoadCommand do
  
  it "should return a Struct for custom queries" do
    results = database.query("SELECT * FROM zoos WHERE name = ?", 'Galveston')
    zoo = results.first
    zoo.class.superclass.should == Struct
    zoo.name.should == "Galveston"
  end
  
end