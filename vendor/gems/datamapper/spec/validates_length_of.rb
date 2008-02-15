context 'A Cow' do
  
  setup do
    class Cow

      include DataMapper::Validations::ValidationHelper
      
      attr_accessor :name, :age
    end
  end
  
  specify('should not have a name shorter than 3 characters') do
    class Cow
      validations.clear!
      validates_length_of :name, :min => 3, :context => :save
    end
    
    betsy = Cow.new
    betsy.valid?.should == true

    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must be more than 3 characters long'

    betsy.name = 'Be'
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must be more than 3 characters long'

    betsy.name = 'Bet'
    betsy.valid?(:save).should == true

    betsy.name = 'Bets'
    betsy.valid?(:save).should == true
  end


  specify('should not have a name longer than 10 characters') do
    class Cow
      validations.clear!
      validates_length_of :name, :max => 10, :context => :save
    end
    
    betsy = Cow.new
    betsy.valid?.should == true
    betsy.valid?(:save).should == true

    betsy.name = 'Testicular Fortitude'
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must be less than 10 characters long'

    betsy.name = 'Betsy'
    betsy.valid?(:save).should == true
  end

  specify('should have a name that is 8 characters long') do
    class Cow
      validations.clear!
      validates_length_of :name, :is => 8, :context => :save
    end
    
    # Context is not save
    betsy = Cow.new
    betsy.valid?.should == true
    
    # Context is :save
    betsy.valid?(:save).should == false

    betsy.name = 'Testicular Fortitude'
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must be 8 characters long'

    betsy.name = 'Samooela'
    betsy.valid?(:save).should == true
  end

  specify('should have a name that is between 10 and 15 characters long') do
    class Cow
      validations.clear!
      validates_length_of :name, :in => (10..15), :context => :save
    end
    
    # Context is not save
    betsy = Cow.new
    betsy.valid?.should == true
    
    # Context is :save
    betsy.valid?(:save)
    betsy.errors.full_messages.first
    
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name must be between 10 and 15 characters long'
    
    betsy.name = 'Smoooooot'
    betsy.valid?(:save).should == false

    betsy.name = 'Smooooooooooooooooooot'
    betsy.valid?(:save).should == false

    betsy.name = 'Smootenstein'
    betsy.valid?(:save).should == true
  end
end