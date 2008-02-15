context 'A new record' do
  
  setup do
    @bob = Person.new(:name => 'Bob', :age => 30, :occupation => 'Sales')
  end
  
  specify 'should be dirty' do
    @bob.dirty?.should == true
  end
  
  specify 'set attributes should be dirty' do
    attributes = @bob.attributes.dup.reject { |k,v| k == :id }
    @bob.dirty_attributes.should == { :name => 'Bob', :age => 30, :occupation => 'Sales' }
  end
  
  specify 'should be marked as new' do
    @bob.new_record?.should == true
  end
  
  specify 'should have a nil id' do
    @bob.id.should == nil
  end
  
end