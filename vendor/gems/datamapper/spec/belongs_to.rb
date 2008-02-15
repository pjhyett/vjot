context 'An Exhibit' do
  
  setup do
    @aviary = Exhibit[:name => 'Monkey Mayhem']
  end
  
  specify 'has a zoo association' do
    @aviary.zoo.class.should == Zoo
    Exhibit.new.zoo.should == nil
  end
  
  specify 'belongs to a zoo' do
    database do |db|
      @aviary.zoo.should == @aviary.session.first(Zoo, :name => 'San Diego')
    end
  end
  
  specify 'can build its zoo' do
    database do |db|
      e = Exhibit.new({:name => 'Super Extra Crazy Monkey Cage'})
      e.zoo.should == nil
      e.build_zoo({:name => 'Monkey Zoo'})
      e.zoo.class == Zoo
      e.zoo.new_record?.should == true
      
      # Need to get associations working properly before this works ....
      e.save
    end
  end
  
  specify 'can build its zoo' do
    database do |db|
      e = Exhibit.new({:name => 'Super Extra Crazy Monkey Cage'})
      e.zoo.should == nil
      e.create_zoo({:name => 'Monkey Zoo'})
      e.zoo.class == Zoo
      e.zoo.new_record?.should == false
      e.save
    end
  end
  
  teardown do
    fixtures('zoos')
    fixtures('exhibits')
  end

end