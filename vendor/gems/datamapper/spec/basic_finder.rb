context 'Finder' do
  
  specify 'database-specific load should not fail' do
    
    DataMapper::database do |db|
      froggy = db.first(Animal, :conditions => ['name = ?', 'Frog'])
      froggy.name.should == 'Frog'
    end

  end
  
  specify 'current-database load should not fail' do
    froggy = DataMapper::database.first(Animal).name.should == 'Frog'
  end
  
  specify 'load through ActiveRecord impersonation should not fail' do
    Animal.find(:all).size.should == 16
  end
  
  specify 'load through Og impersonation should not fail' do
    Animal.all.size.should == 16
  end
  
  specify ':conditions option should accept a hash' do
    Animal.all(:conditions => { :name => 'Frog' }).size.should == 1
  end
  
  specify 'non-standard options should be considered part of the conditions' do
    database.log.debug('non-standard options should be considered part of the conditions')
    zebra = Animal.first(:name => 'Zebra')
    zebra.name.should == 'Zebra'
    
    elephant = Animal[:name => 'Elephant']
    elephant.name.should == 'Elephant'
    
    aged = Person.all(:age => 29)
    aged.size.should == 2
    aged.first.name.should == 'Sam'
    aged.last.name.should == 'Bob'
    
    fixtures(:animals)
  end
  
  specify 'should not find deleted objects' do
    database do
      wally = Animal[:name => 'Whale']
      wally.destroy!.should == true
    
      wallys_evil_twin = Animal[:name => 'Whale']
      wallys_evil_twin.should == nil
    
      wally.new_record?.should == true
      wally.save
    
      Animal[:name => 'Whale'].should == wally
    end
  end
  
  specify 'lazy-loads should issue for whole sets' do
    people = Person.all
    
    people.each do |person|
      person.notes
    end
  end
  
end