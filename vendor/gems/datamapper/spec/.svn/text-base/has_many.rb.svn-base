describe DataMapper::Associations::HasManyAssociation do
  
  before(:all) do
    fixtures(:zoos)
    fixtures(:exhibits)
    
    @san_diego = Zoo[:name => 'San Diego']
    @dallas = Zoo[:name => 'Dallas']
    @miami = Zoo[:name => 'Miami']
  end
    
  it 'should expose a proxy for the accessor' do
    [@miami, Zoo.new].each do |z|
      z.exhibits.class.should == DataMapper::Associations::HasManyAssociation
    end
  end
  
  it 'should lazily-load the association when Enumerable methods are called' do
    database do |db|
      @san_diego.exhibits.size.should == 2
      @san_diego.exhibits.should include(@san_diego.session.first(Exhibit, :name => 'Monkey Mayhem'))
    end
  end
  
  it 'should eager-load associations for an entire set' do
    zoos = Zoo.all
    zoos.each do |zoo|
      zoo.exhibits.each do |exhibit|
        exhibit.zoo.should == zoo
      end
    end
  end
  
end