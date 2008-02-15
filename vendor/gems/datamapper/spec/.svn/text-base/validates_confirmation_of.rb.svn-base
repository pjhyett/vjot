context 'A Cow' do
  
  setup do
    class Cow

      include DataMapper::Validations::ValidationHelper
      
      attr_accessor :name, :name_confirmation, :age
    end
  end
  
  specify('') do
    class Cow
      validations.clear!
      validates_confirmation_of :name, :context => :save
    end
    
    betsy = Cow.new
    betsy.valid?.should == true

    betsy.name = 'Betsy'
    betsy.name_confirmation = ''
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name does not match the confirmation'

    betsy.name = ''
    betsy.name_confirmation = 'Betsy'
    betsy.valid?(:save).should == false
    betsy.errors.full_messages.first.should == 'Name does not match the confirmation'

    betsy.name = 'Betsy'
    betsy.name_confirmation = 'Betsy'
    betsy.valid?(:save).should == true
  end
  
end