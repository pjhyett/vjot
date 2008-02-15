require 'active_record'

ActiveRecord::Base.establish_connection :adapter => 'postgresql',
  :host     => 'localhost',
  :username => 'postgres',
  :password => '',
  :database => 'data_mapper_1'
      
class ARAnimal < ActiveRecord::Base
  set_table_name 'animals'
end

class ARPerson < ActiveRecord::Base
  set_table_name 'people'
end

require 'lib/data_mapper'

log_path = File.dirname(__FILE__) + '/development.log'

require 'fileutils'
FileUtils::rm log_path if File.exists?(log_path)

DataMapper::Database.setup do
  adapter   'postgresql'
  username 'postgres'
  database 'data_mapper_1'
end

class DMAnimal < DataMapper::Base
  set_table_name 'animals'
  property :name, :string
  property :notes, :string, :lazy => true
end

class DMPerson < DataMapper::Base
  set_table_name 'people'
  property :name, :string
  property :age, :integer
  property :occupation, :string
  property :notes, :text, :lazy => true
end

class Exhibit < DataMapper::Base
  property :name, :string
  belongs_to :zoo
end

class Zoo < DataMapper::Base
  property :name, :string
  has_many :exhibits
end

class ARZoo < ActiveRecord::Base
  set_table_name 'zoos'
  has_many :exhibits, :class_name => 'ARExhibit', :foreign_key => 'zoo_id'
end

class ARExhibit < ActiveRecord::Base
  set_table_name 'exhibits'
  belongs_to :zoo, :class_name => 'ARZoo', :foreign_key => 'zoo_id'
end

N = (ENV['N'] || 1000).to_i

Benchmark::send(ENV['BM'] || :bmbm, 40) do |x|
  
  x.report('ActiveRecord:id') do
    N.times { ARAnimal.find(1) }
  end
  
  x.report('DataMapper:id') do
    N.times { DMAnimal[1] }
  end
  
  x.report('ActiveRecord:all') do
    N.times { ARAnimal.find(:all) }
  end
  
  x.report('DataMapper:all') do
    N.times { DMAnimal.all }
  end
  
  x.report('ActiveRecord:conditions') do
    N.times { ARZoo.find(:first, :conditions => ['name = ?', 'Galveston']) }
  end
  
  x.report('DataMapper:conditions:short') do
    N.times { Zoo[:name => 'Galveston'] }
  end
  
  x.report('DataMapper:conditions:long') do
    N.times { Zoo.find(:first, :conditions => ['name = ?', 'Galveston']) }
  end
  
  people = [
    ['Sam', 29, 'Programmer'],
    ['Amy', 28, 'Business Analyst Manager'],
    ['Scott', 25, 'Programmer'],
    ['Josh', 23, 'Supervisor'],
    ['Bob', 40, 'Peon']
    ]

  DMPerson.truncate!
  
  x.report('ActiveRecord:insert') do
    N.times do
      people.each do |a|
        ARPerson::create(:name => a[0], :age => a[1], :occupation => a[2])
      end
    end
  end
  
  DMPerson.truncate!
  
  x.report('DataMapper:insert') do
    N.times do
      people.each do |a|
        DMPerson::create(:name => a[0], :age => a[1], :occupation => a[2])
      end
    end
  end
  
  x.report('ActiveRecord:update') do
    N.times do
      bob = ARAnimal.find(:first, :conditions => ["name = ?", 'Elephant'])
      bob.notes = 'Updated by ActiveRecord'
      bob.save
    end
  end
  
  x.report('DataMapper:update') do
    N.times do
      bob = DMAnimal.first(:name => 'Elephant')
      bob.notes = 'Updated by DataMapper'
      bob.save
    end
  end
  
  x.report('ActiveRecord:associations:lazy') do
    N.times do
      zoos = ARZoo.find(:all)
      zoos.each { |zoo| zoo.exhibits.entries }
    end
  end
  
  x.report('ActiveRecord:associations:included') do
    N.times do
      zoos = ARZoo.find(:all, :include => [:exhibits])
      zoos.each { |zoo| zoo.exhibits.entries }
    end
  end
  
  x.report('DataMapper:associations') do
    N.times do
      database do
        Zoo.all.each { |zoo| zoo.exhibits.entries }
      end
    end
  end
end