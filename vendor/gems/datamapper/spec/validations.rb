context 'Validations' do
  
  setup do
    class Cow
      
      include DataMapper::Validations::ValidationHelper
      
      attr_accessor :name, :age
    end
  end
  
  specify('should allow you to specify not-null fields in different contexts') do
    class Cow
      validations.clear!
      validates_presence_of :name, :context => :save
    end
    
    betsy = Cow.new
    betsy.valid?.should == true

    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must not be blank'
    
    betsy.name = 'Betsy'
    betsy.valid?(:save).should == true
  end
  
  specify('should be able to use ":on" for a context alias') do
    class Cow
      validations.clear!
      validates_presence_of :name, :age, :on => :create
    end
    
    maggie = Cow.new
    maggie.valid?.should == true
    
    maggie.valid?(:create).should == false
    maggie.errors.full_messages.should include('Age must not be blank')
    maggie.errors.full_messages.should include('Name must not be blank')
    
    maggie.name = 'Maggie'
    maggie.age = 29
    maggie.valid?(:create).should == true
  end
  
  specify('should default to a general context if unspecified') do
    class Cow
      validations.clear!
      validates_presence_of :name, :age
    end
    
    rhonda = Cow.new
    rhonda.valid?.should == false
    
    rhonda.errors.full_messages.should include('Age must not be blank')
    rhonda.errors.full_messages.should include('Name must not be blank')
    
    rhonda.name = 'Rhonda'
    rhonda.age = 44
    rhonda.valid?.should == true
  end  
  
end