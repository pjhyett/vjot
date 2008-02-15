context 'An Employee' do
  
  setup do
    class Employee

      include DataMapper::Validations::ValidationHelper
      
      attr_accessor :email
    end
  end
  
  specify('must have a valid email address') do
    class Employee
      validations.clear!
      validates_format_of :email, :as => :email_address, :on => :save
    end
    
    e = Employee.new
    e.valid?.should == true

    [
      'test test@example.com', 'test@example', 'test#example.com',
      'tester@exampl$.com', '[scizzle]@example.com', '.test@example.com'
    ].all? { |test_email|
      e.email = test_email
      e.valid?(:save).should == false
      e.errors.full_messages.first.should == "#{test_email} is not a valid email address"
    }

    e.email = 'test@example.com'
    e.valid?(:save).should == true
  end
  
  specify('must have a valid organization code') do
    class Employee
      validations.clear!
      
      attr_accessor :organization_code
      
      # WARNING: contrived example
      # The organization code must be A#### or B######X12
      validates_format_of :organization_code, :on => :save, :with => lambda { |code|
        (code =~ /A\d{4}/) || (code =~ /[B-Z]\d{6}X12/)
      }
    end
    
    e = Employee.new
    e.valid?.should == true
    
    e.organization_code = 'BLAH :)'
    e.valid?(:save).should == false
    e.errors.full_messages.first.should == 'Organization code is invalid'

    e.organization_code = 'A1234'
    e.valid?(:save).should == true

    e.organization_code = 'B123456X12'
    e.valid?(:save).should == true
  end
  
end