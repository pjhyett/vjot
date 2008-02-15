=begin
context 'Sub-selection' do
  
  specify 'should return a Cup' do
    Animal[:id.select => { :name => 'cup' }].name.should == 'Cup'
  end
  
  specify 'should return all exhibits for Galveston zoo' do
    Exhibit.all(:zoo_id.select(Zoo) => { :name => 'Galveston' }).size.should == 3
  end
  
  specify 'should allow a sub-select in the select-list' do
    Animal[:select => [ :id.count ]]
  end
end
=end