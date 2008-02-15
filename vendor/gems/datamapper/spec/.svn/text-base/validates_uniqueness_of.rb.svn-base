context 'An Animal' do
  
  specify('must have a unique name') do
    class Animal
      validations.clear!
      validates_uniqueness_of :name, :context => :save
    end
    
    bugaboo = Animal.new
    bugaboo.valid?.should == true

    bugaboo.name = 'Bear'
    bugaboo.valid?(:save).should == false
    bugaboo.errors.full_messages.first.should == 'Name has already been taken'

    bugaboo.name = 'Bugaboo'
    bugaboo.valid?(:save).should == true
  end
  
end

context 'A Person' do
  setup do 
    fixtures 'people'
  end
  
  specify('must have a unique name for their occupation') do
    class Person
      validations.clear!
      validates_uniqueness_of :name, :context => :save, :scope => :occupation
    end
    
    new_programmer_scott = Person.new(:name => 'Scott', :age => 29, :occupation => 'Programmer')
    garbage_man_scott = Person.new(:name => 'Scott', :age => 25, :occupation => 'Garbage Man')
    
    # Should be valid even though there is another 'Scott' already in the database
    garbage_man_scott.valid?(:save).should == true

    # Should NOT be valid, there is already a Programmer names Scott, adding one more
    # would destroy the universe or something
    new_programmer_scott.valid?(:save).should == false
    new_programmer_scott.errors.full_messages.first.should == "Name has already been taken"
  end
  
end